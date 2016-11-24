---
layout: page
title:  File
subtitle: Envio de arquivos (*upload*).
comments: true
---

Este tipo é responsável pelo *upload* e visualização de arquivos nos formulários das instâncias do Titan. Ele herda de "Integer" pois o dado que é salvo dentro do banco é um número que representa o arquivo na estrutura de *upload* da instância.

Na prática, todo arquivo enviado por meio deste campo é inserido na pasta de arquivos da instância (definida no atributo '**data-path**' da *tag* '**archive**' do arquivo "**configure/titan.xml**") e é referenciado por uma tupla criada na tabela mandatória '**_file**' (no *schema* padrão do Titan). Desta forma, o valor inserido por este campo será o da chave entrageira para esta tabela. Assim, para utilizá-lo, basta criar a seguinte estrutura no banco de dados:

{% highlight sql linenos %}
ALTER TABLE tabela ADD COLUMN coluna INTEGER;
ALTER TABLE tabela ADD CONSTRAINT coluna_file_fk FOREIGN KEY (coluna) REFERENCES _file (_id) ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
{% endhighlight %}

Na figura abaixo é mostrado um campo deste tipo.

![Utilizando um campo do tipo "File" para vincular ao formulário em edição um arquivo previamente enviado à instância.](/docs/types/file/image_0.png)

Este campo possui alguns atributos específicos. São eles:

- **owner-only:** Quando este atributo existe e têm valor '*true*', os arquivos previamente listados para associação são apenas aqueles que foram enviados pelo usuário;
- **show-details:** Por padrão este atributo possui valor '*true*'. Quando ativo, irá exibir ao lado do arquivo associado as seguintes informações: nome do arquivo, tamanho (em *bytes*), *mime type* e descrição (se houver); e
- **resolution:** Quando for uma imagem, o valor deste atributo determinará as dimensões do *thumbnail*](http://pt.wikipedia.org/wiki/Thumbnail) exibido.
- **owner-only:** Veja abaixo.
- **public:** Veja abaixo.

Além destes atributos, este tipo permite que seja declarada uma lista de *tags* "**mime-type**" internas. Trata-se dos tipos de arquivos (identificados por seu [MIME Type](http://en.wikipedia.org/wiki/Internet_media_type)) que o campo aceitará. Estes tipos devem ter sido previamente declarados no arquivo de configuração "**configure/archive.xml**". Caso não seja declarada nenhuma restrição no *field*, ou seja, não haja nehuma *tag* "**mime-type**" interna, o campo aceitará todos os tipos de arquivo habilitados para a instância.

Por exemplo, para declarar um campo que aceita apenas imagens, teríamos:

{% highlight xml linenos %}
<field
	type="File"
	column="photo"
	label="Photo | pt_BR: Foto"
	tip="200 x 200 pixels"
	owner-only="true"
	show-details="false"
	resolution="200"
	help="Resolução recomendada de 200 pixels de largura por 200 pixels de altura.">
	<mime-type>image/jpeg</mime-type>
	<mime-type>image/gif</mime-type>
	<mime-type>image/pjpeg</mime-type>
	<mime-type>image/png</mime-type>
	<mime-type>image/x-bitmap</mime-type>
	<mime-type>image/photoshop</mime-type>
	<mime-type>image/bmp</mime-type>
</field>
{% endhighlight %}

Assim como no novo tipo [Fck](/docs/types/fck), o tipo 'File' suporta a exibição de arquivos multimídia (ou seja, **vídeo** e **aúdio**, além de **imagens**) utilizando o player nativo do HTML5. Para que esta funcionalidade funcione corretamente, é necessário ter o utilitário "**avconv**" instalado no servidor.

Para instalar o "avconv" no Windows, baixe a biblioteca "libav" no link abaixo, descompacte-a em seu sistema de arquivos e insira o caminho absoluto até a pasta "usr\bin" da biblioteca no path de seu Windows.

[http://builds.libav.org/windows/](http://builds.libav.org/windows/)

Para instalar no Debian, faça:

{% highlight bash linenos %}
su -
aptitude update
aptitude install libav-tools
{% endhighlight %}

![image alt text](image_2.png)

O re-aproveitamento de arquivos já enviados também é facilitado. Basta clicar sobre a imagem em formato de "**arquivo morto**" para acessar o módulo de busca de arquivos.

É importantíssimo atentar-se para dois atributos do tipo. O primeiro é o "**owner-only**". Por padrão este atributo tem valor '*false*', ou seja, significa que o usuário que está acessando o mecanismo de busca verá todos os arquivos públicos enviados para o sistema. Caso você coloque este atributo com valor '*true*', o usuário verá apenas os arquivos que ele mesmo enviou.

O outro atributo é o '**public**'. Por padrão este atributo é '*true*', o que significa que um arquivo enviado pelo campo será público. Caso seja setado para '*false*', o arquivo jamais será listado para outros usuários no módulo de buscas (mesmo que o "**owner-only**" seja '*false*'). Outro ponto importantíssimo sobre este atributo é que, devido à natureza do Titan (para a criação de CMSs de sites), os arquivos públicos podem ser visualizados por qualquer pessoa que tenha o link para ele, mesmo que não logado no sistema. Quando o arquivo não é público (valor do atributo igua a '*false*'), o Titan gera uma *hash* que passa a ser necessária para o arquivo ser aberto.

O tipo suporta **9.223.372.036.854.775.807 arquivos**, ou seja, é virtualmente limitado apenas pelo espaço no servidor. O tamanho máximo dos arquivos enviados será o menor valor entre três diretivas do PHP: [*upload_max_filesize*](https://secure.php.net/manual/pt_BR/ini.core.php#ini.upload-max-filesize), [*post_max_size*](https://secure.php.net/manual/pt_BR/ini.core.php#ini.post-max-size) e [*memory_limit*](https://secure.php.net/manual/pt_BR/ini.core.php#ini.memory-limit).
