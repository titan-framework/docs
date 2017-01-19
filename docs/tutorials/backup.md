---
layout: page
title: Backup On Demand
subtitle: Backup da aplicação pela interface.
comments: true
---

Sistema de **backup sob demanda** no Titan. Este recurso ajuda administradores de qualquer instância do Titan a garantir a segurança dos dados, uma vez que pode-se gerar um backup do sistema a qualquer momento pela interface gráfica do sistema.

A restrição é que instância precisa, necessariamente, estar rodando em um ambiente **Linux**.

Para utilizar é bem simples. O primeiro passo é criar um nova pasta, com direitos de escrita pelo usuário do Apache (ou Nginx). Por exemplo, vamos supor que seja criado uma pasta denominada '**backup**' na raiz da instância.

Agora, é necessário habilitar a funcionalidade inserindo a seguinte TAG no arquivo '**configure/titan.xml**':

```xml
<backup
	path="backup/"
	validity="86400"
	timeout="43200"
/>
```

O atributo '**path**' é o caminho para a pasta onde os backups serão gravados.

O atributo '**validity**' é o tempo, em segundos, que os links permanecerão ativos. Backups mais antigos do que o tempo aqui estipulado serão apagados pelo Scheduler Job padrão ou na próxima vez que o backup sob demanda for executado. O valor padrão é 1 dia (86.400 segundos).

O '**timeout**' é o tempo máximo que o script poderá ser executado. Ele não pode ser '0' (zero). O valor padrão é 12 horas (43.200 segundos).

Além disso, é fundamental que a instância possa acessar o DB sem a necessidade de senha. Há algumas formas de possibilitar isto:

- A primeira é configurar, no "**pg_hba.conf**", que o método de autenticação para conexões por sockets Unix seja "_trust_". Este método irá funcionar apenas para DBs rodando em "localhost", ou seja, no mesmo servidor da instância. Vale lembrar que conexões via sockets Unix ocupam menos memória do servidor e possuem um overhead menor do que conexões TCP/IP. Sempre que rodando em uma máquina Linux e acessando um DB em 'localhost' o Titan utiliza sockets Unix para aproveitar esta vantagem.
- No caso da instância estar acessando um DB que não esteja no mesmo servidor ('localhost') será necessário efetuar a conexão por TCP/IP. Neste caso, é possível habilitar no "**pg_hba.conf**" do servidor de PostgreSQL para que o método de autenticação para a conexão específica do IP do servidor Web que contém a instância seja "_trust_".
- Por fim, outra sugestão é inserir na pasta do usuário do Apache (no caso de Debian e Ubuntu o usuário padrão é o 'www-data' e a pasta é a "/var/www") um arquivo denominado '**.pgpass**' com uma linha com os dados de conexão na sintaxe "**hostname:port:database:username:password**". Isto fará com que o usuário 'www-data' possa conectar, sem indagação de senha, apenas no DB específico da instância.

Feito estes procedimentos o recurso de *backup on demand* será habilitado. Apenas usuários que pertençam a um grupo com direito de administrador poderão utilizá-lo. Para estes usuários irá aparecer um novo botão, comforme mostrado abaixo.

![](/docs/tutorials/backup/fig1.png)

Ao clicar, o usuário poderá selecionar o que deseja que seja 'backupeado'. As opções são mostradas abaixo.

![](/docs/tutorials/backup/fig2.png)

Ao avançar, o sistema inicia o backup em _background_ e o usuário pode deslogar do sistema sem problemas. Ao término do processo é enviado um e-mail com os links para realização do download dos artefatos selecionados.

![](/docs/tutorials/backup/fig3.png)
