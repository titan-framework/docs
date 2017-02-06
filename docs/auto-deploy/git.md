---
layout: page
title: Auto-Deploy/GIT
subtitle: Configurando um robô para deploy automático de instâncias em repositórios GIT.
comments: true
---

Este _script_ de _auto-update_ para instâncias do Titan objetiva manter instâncias atualizadas em ambientes remotos de teste, homologação e/ou produção a partir da consulta sistemática ao repositório GIT onde está versionado seu código. Caso sua instância utilize um repositório de código SVN, por favor, acesse as instruções para ativação do [_script_ de _auto-deploy_ para instâncias em repositórios SVN](/docs/auto-deploy/svn). Este _script_ funciona delegando ao _schedular job_ do sistema operacional a tarefa de manter a instância atualizada no servidor.

O _script_ é baseado no conceito de _database migrations_ implementado pelo [Ruby on Rails](http://guias.rubyonrails.com.br/migrations.html), que nada mais é que a gestão e rastreabilidade de mudanças incrementais no banco de dados da aplicação.

Para que o _script_ de _auto-update_ funcione corretamente é necessário criar na raiz da instância a seguinte estrutura de diretórios (caso não exista):

```bash
MyApp/
  configure/
  section/
  ...
  update/
    db/
      20130220123401.sql
      20130225021401.sql
      20130227234701.sql
      ...
```

Na pasta '**update/db**' ficam as alterações a serem aplicadas no banco de dados. As alterações devem sempre ser colocadas no formato '**YYYYMMDDHHUUNN.sql**', onde: 'YYYY' é o ano, 'MM' é o mês, 'DD' é o dia, 'HH' é a hora, 'UU' é o minuto e 'NN' é um número sequencial iniciado em 01 (para cada minuto). Estes valores são referentes ao momento em que o arquivo é criado. O nome do arquivo é a versão do banco de dados.

Além disso, a sua _work copy_ do projeto deve estar clonada com uso de uma _SSH Key_ cadastrada no repositório. Nesta modalidade, o GIT não solicitará login e senha para atualizar o código da _work copy_ (_pull_). Veja como cadastrar a _SSH Key_ no [GitHub](https://help.github.com/articles/connecting-to-github-with-ssh/) e no [GitLab](https://docs.gitlab.com/ce/ssh/README.html).

Além da criação desta estrutura você precisa inserir configurações adicionais no 'configure/titan.xml' da sua instância:

{% highlight xml linenos %}
<titan-configuration ...>
    ...
    <update
        environment="test"
        backup="true"
        file-mode="664"
        dir-mode="775"
        owner="root"
        group="staff"
    />
</titan-configuration>
{% endhighlight %}

O atributo '**environment**' diz qual é o ambiente em que a instância está executando. Deve existir no seu repositório GIT uma _branch_ homônima. O sistema de _auto-deploy_ irá "vigiar" esta _branch_ buscando novas _tags_, ou seja, para informa o _script_ que uma nova versão deve ser disponibilizada no ambiente, basta criar uma nova _tag_ nesta _branch_. Deve-se, portanto, controlar quem pode publicar código no ambiente por meio das permissões de _commit_ e _merge_ da _branch_. Por exemplo, todos os desenvolvedores podem commitar código para a _branch_ '_master_' e fazer _merge_ da '_master_' na '_test_', mas somente os gerentes de projeto podem fazer _merge_ da '_test_' na '_production_'.

Recomenda-se fortemente que os nomes das _tags_ criadas nas _branches_ sigam o padrão [Semantic Versioning 2.0.0](http://semver.org). Mais especificamente, cada _tag_ é nomeada no formato **V.YY.MM-pPP**, onde:

- **V** é a versão-macro em desenvolvimento da aplicação;
- **YY.MM** é o _milestone_, representado por ano e mês (com dois dígitos cada) da data prevista (_due date_); e
- **PP** é o _build_, ou seja, um valor incremental iniciando em '1' ou vazio dentro de um mesmo _milestone_.

Na figura baixo podem ser observados os três _branches_ principais (perenes) do repositório GIT de uma instância do Titan que utiliza o _script_ de _auto-deploy_. Os _branches_ '_test_' e '_production_' permitem o _deploy_ automatizado do código nos ambientes de teste e produção, respectivamente. Para isso, foram criadas _tags_ toda vez que era necessário efetuar a atualização. Por exemplo, a _tag_ '2.16.12-p39' corresponde ao _build_ '39' do _milestone_ '16.12' da macro-versão '2' desta aplicação.

![](/docs/auto-deploy/01.png)

Seguindo este padrão de nomes, o Titan irá disponibilizar na interface da instância o acesso ao número completo da versão da aplicação, atualizando esta informação toda ves que a _work copy_ passar pelo processo de auto-deploy.

![](/docs/auto-deploy/02.png)

É importante que a sua _work copy_ seja, portanto, um clone da _branch_ declarada na configuração. Você pode utilizar o [_script_ de instalação da instância (_deploy_)](/docs/deploy) para facilitar a publicação da aplicação Web de forma adequada ao _auto-deploy_.

O atributo '**backup**' diz se deverá ou não ser realizado o _backup_ do banco de dados antes que sejam aplicadas alterações. Repare que o _backup_ apenas será efetuado se houverem alterações a serem aplicadas no DB. **Atenção!** Caso não seja explicitamente setado o valor "_false_" nesta diretiva, o _script_ de _auto-update_ sempre tentará fazer o _backup_, ou seja, o valor padrão deste atributo é "_true_". A pasta de _backup_ será a mesma utilizada pela funcionalidade [_backup on demand_](/docs/tutorials/backup/). Após a validade setada nesta funcionalidade os arquivos de _backup_ do _auto-update_ serão automaticamente apagados, preservando o espaço fisíco do servidor.

As demais configurações ('**file-mode**', '**dir-mode**', '**owner**' e '**group**') devem ser setadas apenas caso a instância não esteja em um ambiente [Debian](http://debian.org). Referem-se às permissões que os arquivos atualizados receberão.

A primeira vez que o _script_ é executado ele cria automaticamente uma tabela "**_version**" no _schema_ do Titan no banco de dados. Esta tabela irá controlar as versões do BD, o autor da modificação e quando ela foi aplicada.

O _script_ funciona da seguinte forma:

1. Primeiro ele captura a versão (_tag_) atual da _work copy_ no ambiente local e a _tag_ mais recente na _branch_ no repositório remoto (_origin_);
2. Havendo diferença entre as versões, o script atualiza o código da _work copy_ para a versão (_tag_) mais recente;
3. Em seguida, verifica qual a última versão do banco de dados (tabela "\_version") e verifica se existem arquivos do _database migrations_ a serem aplicados;
4. Caso exista, ele efetua _backup_ do DB;
5. Então, ele aplica as alterações no DB. Caso ocorra erro, é realizado um _rollback_ no DB e a _work copy_ é revertida para a versão (_tag_) original.

Desta forma, mesmo um sistema que esteja sendo instanciado no servidor a partir de um _backup_ antigo terá todas as revisões metodicamente aplicadas recursivamente.

Vale lembrar que, indepentende da quantidade de iterações do laço que possuam alterações a serem aplicadas no DB, o _script_ irá gerar, por execução, apenas um _backup_ inicial (e somente se houver alterações a serem aplicadas).

Para que o _script_ funcione é necessário que esteja executando em um servidor _*NIX_, sendo que está homologado especificamente para Debian Jessie.

Para executar o _script_ basta chamá-lo passando como parâmetro todas as instâncias que deseja atualizar (sem limite de instâncias). O _script_ em si (que deverá ser chamado) está localizado na pasta '**update**' do _core_ do Titan. Por exemplo:

```bash
php /var/www/titan/update/update.php /var/www/portal/gestor/ /var/www/sigadhoc/ /var/www/fundect/manager/
```

No exemplo acima o _script_ irá atualizar em sequência as três instâncias passadas. Lembrando que cada uma delas deverá ter a pasta '**update**' (como a estrutura de pastas descrita) e deverá ter a tag '**\<update />**' em seu '**configure/titan.xml**'.

Conhecendo o funcionamento do _script_ basta agora inserí-lo no _schedular job_ do sistema operacional. No caso do Linux edite o arquivo "**/etc/crontab**" inserindo a linha abaixo:

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
