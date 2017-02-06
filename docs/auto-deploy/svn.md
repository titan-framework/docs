---
layout: page
title: Auto-Deploy/SVN
subtitle: Configurando um robô para deploy automático de instâncias em repositórios SVN.
comments: true
---

Este _script_ de _auto-update_ para instâncias do Titan objetiva manter instâncias atualizadas em ambientes remotos de teste, homologação e/ou produção a partir da consulta sistemática ao repositório de código SVN onde está versionado seu código. Caso sua instância utilize um repositório de código GIT, por favor, acesse as instruções para ativação do [_script_ de _auto-deploy_ para instâncias em repositórios GIT](/docs/auto-deploy/git). Este _script_ funciona delegando ao _schedular job_ do sistema operacional a tarefa de manter a instância atualizada no servidor.

O _script_ é baseado no conceito de _database migrations_ implementado pelo [Ruby on Rails](http://guias.rubyonrails.com.br/migrations.html), que nada mais é que a gestão e rastreabilidade de mudanças incrementais no banco de dados da aplicação.

Para que o _script_ de _auto-update_ funcione corretamente é necessário criar na raiz da instância a seguinte estrutura de diretórios (caso não exista):

```bash
MyApp/
  configure/
  section/
  ...
  update/
    app/
      production.txt
      test.txt
      ...
    db/
      20130220123401.sql
      20130225021401.sql
      20130227234701.sql
      ...
    blacklist.txt
```

Os arquivos TXT dentro da pasta '**update/app**' relatarão quais arquivos devem ser atualizados naquela revisão. São chamados de "arquivos de caminhos" ("_file of paths_"). O nome do arquivo define o ambiente em que a atualização será aplicada.

Na pasta '**update/db**' ficam as alterações a serem aplicadas no banco de dados. As alterações devem sempre ser colocadas no formato '**YYYYMMDDHHUUNN.sql**', onde: 'YYYY' é o ano, 'MM' é o mês, 'DD' é o dia, 'HH' é a hora, 'UU' é o minuto e 'NN' é um número sequencial iniciado em 01 (para cada minuto). Estes valores são referentes ao momento em que o arquivo é criado. O nome do arquivo é a versão do banco de dados.

Além da criação desta estrutura você precisa inserir configurações adicionais no 'configure/titan.xml' da sua instância:

{% highlight xml linenos %}
<titan-configuration ...>
    ...
    <update
        environment="test"
        svn-login="update"
        svn-password=""
        svn-users="camilo"
        backup="true"
        file-mode="664"
        dir-mode="775"
        owner="root"
        group="staff"
    />
</titan-configuration>
{% endhighlight %}

O atributo '**environment**' diz qual é o ambiente em que a instância está executando. É fundamental para que o _script_ saiba qual _file of paths_ deverá considerar. Os atributos '**svn-login**' e '**svn-password**' devem ser configurados com um usuário e senha do repositório SVN com o código da instância. O atributo '**svn-users**' define quais usuários possuem _commits_ que podem ser atualizados, ou seja, caso seja commitado um _file of paths_ por um usuário não especificado nesta diretiva, ele será desconsiderado no momento do _update_. O atributo '**backup**' diz se deverá ou não ser realizado o backup do banco de dados antes que sejam aplicadas alterações. Repare que o _backup_ apenas será efetuado se houverem alterações a serem aplicadas no DB. **Atenção!** Caso não seja explicitamente setado o valor "_false_" nesta diretiva, o _script_ de _auto-update_ sempre tentará fazer o _backup_, ou seja, o valor padrão deste atributo é "_true_". A pasta de _backup_ será a mesma utilizada pela funcionalidade [_backup on demand_](/docs/tutorials/backup/). Após a validade setada nesta funcionalidade os arquivos de _backup_ do _auto-update_ serão automaticamente apagados, preservando o espaço fisíco do servidor.

As demais configurações ('**file-mode**', '**dir-mode**', '**owner**' e '**group**') devem ser setadas apenas caso a instância não esteja em um ambiente [Debian](http://debian.org). Referem-se às permissões que os arquivos atualizados receberão.

A primeira vez que o _script_ é executado ele cria automaticamente uma tabela "**_version**" no _schema_ do Titan no banco de dados. Esta tabela irá controlar as versões do BD, o autor da modificação e quando ela foi aplicada.

O _script_ funciona da seguinte forma:

1. Primeiro ele captura a versão atual da _work copy_ no servidor e a _head revision_ do _file of paths_ para o ambiente no repositório SVN;
2. Por meio de um laço ele atualiza o _file of paths_ para a versão posterior (revisão atual + 1);
3. Para cada iteração do laço, ele atualiza a pasta 'update/db' para a mesma revisão e verifica qual a última versão do banco de dados (tabela "_version");
4. Com base na última revisão do DB, o _script_ atualiza para a _head revision_ cada arquivo a ser aplicado no DB individualmente;
5. Em seguida, ele efetua backup do DB;
6. Então, ele aplica as alterações no DB. Caso ocorra erro, é realizado um _rollback_ no DB e o _file of paths_ é atualizado para a última revisão corretamente aplicada;
7. Em caso de sucesso os arquivos (_paths_) listados no _file of paths_ são atualizados para a revisão da iteração; e
8. Por fim, não havendo problemas, esta revisão passa a ser a última revisão estável e o laço avança para a próxima iteração.

Desta forma, mesmo um sistema que esteja sendo instanciado no servidor a partir de um _backup_ antigo terá todas as revisões metodicamente aplicadas recursivamente.

Vale lembrar que, indepentende da quantidade de iterações do laço que possuam alterações a serem aplicadas no DB, o _script_ irá gerar, por execução, apenas um _backup_ inicial (e somente se houver alterações a serem aplicadas).

Repare também na existência do arquivo "**update/backlist.txt**". Neste arquivo podem ser colocadas revisões que devem ser desconsideradas. Assim, o _script_ sempre atualiza este arquivo para a _head revision_ e consulta seu conteúdo, permitindo manipular as revisões que serão de fato aplicadas.

Para que o _script_ funcione é necessário que esteja executando em um servidor _*NIX_, sendo que está homologado especificamente para Debian Jessie. Será necessário também instalar a biblioteca SVN. Caso seu Debian seja a versão Squeeze ou inferior, recomenda-se instalar a biblioteca via PECL:

```bash
su -
aptitude update
aptitude install build-essential php-pear php5-dev libsvn-dev
pecl update-channels
pecl install svn
echo "extension=svn.so" > /etc/php5/conf.d/svn.ini
/etc/init.d/apache2 restart
```

Caso esteja utilizando o Debian Jessie, basta instalar o pacote via _aptitude_:

```bash
su -
aptitude update
aptitude install php5-svn
```

**Atenção!** Até a escrita deste documento, a biblioteca SVN não esteva disponível para o PHP 7. Neste caso, recomenda-se fortemente o uso de [repositórios GIT](/docs/auto-deploy/git) ou a instalação da biblioteca via PECL.

Para executar o _script_ basta chamá-lo passando como parâmetro todas as instâncias que deseja atualizar (sem limite de instâncias). O _script_ em si (que deverá ser chamado) está localizado na pasta '**update**' do _core_ do Titan. Por exemplo:

```bash
php /var/www/titan/update/update.php /var/www/portal/gestor/ /var/www/sigadhoc/ /var/www/fundect/manager/
```

No exemplo acima o _script_ irá atualizar em sequência as três instâncias passadas. Lembrando que cada uma delas deverá ter a pasta '**update**' (como a estrutura de pastas descrita) e deverá ter a tag '**\<update />**' em seu '**configure/titan.xml**'.

Conhecendo o funcionamento do script basta agora inserí-lo no _schedular job_ do sistema operacional. No caso do Linux edite o arquivo "**/etc/crontab**" inserindo a linha abaixo:

```bash
*/5 * * * * root /usr/bin/php /var/www/[caminho para o Titan]/update/update.php /var/www/[caminho para a primeira instância] /var/www/[caminho para a segunda instância] > [arquivo com log de saída]
```

Neste caso o script irá executar a cada 5 minutos. Altere o número '5' para aumentar o período de tempo.

Por exemplo:

```bash
*/20 * * * * root /usr/bin/php /var/www/titan/update/update.php /var/www/portal/gestor/ /var/www/sigadhoc/ /var/www/fundect/manager/ > /var/log/titan-auto-update.log
```

Ou seja, na configuração acima as três instâncias do nosso exemplo inicial serão atualizadas a cada 20 minutos e o LOG será jogado no arquivo "/var/log/titan-auto-update.log". Lembre-se de reiniciar o CRON após editar o '/etc/crontab':

```bash
/etc/init.d/cron restart
```

Quando de fato a instância é atualizada, ao invés de jogar no LOG as informações da atualização (apenas da instância específica) são enviadas para o(s) e-mail(s) cadastrado(s) na diretiva 'e-mail' da tag '\<titan-configuration />' do arquivo 'configure/titan.xml' da instância e para os e-mails de todos os usuários que estejam associados a grupos com perfil de administrador.
