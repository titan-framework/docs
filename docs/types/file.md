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


Este campo permite também que o usuário vincule ao formulário em edição um arquivo que já tenha sido enviado em outra oportunidade. Este recurso é uma forma de evitar arquivos redundantes, poupando espaço do servidor. Para vincular estes arquivos, basta que o usuário digite uma parte do nome do arquivo no campo (pelo menos três caracteres) que aparecerá uma lista de possíveis arquivos para que ele escolha o que deseja vincular. Na figura abaixo é mostrada esta funcionalidade.

![Utilizando um campo do tipo "File" para vincular ao formulário em edição um arquivo previamente enviado à instância.](/docs/images/image_14.png)

Este campo possui alguns atributos específicos. São eles:

- **owner-only:** Quando este atributo existe e têm valor '*true*', os arquivos previamente listados para associação são apenas aqueles que foram enviados pelo usuário;
- **show-details:** Por padrão este atributo possui valor '*true*'. Quando ativo, irá exibir ao lado do arquivo associado as seguintes informações: nome do arquivo, tamanho (em *bytes*), *mime type* e descrição (se houver); e
- **resolution:** Quando for uma imagem, o valor deste atributo determinará as dimensões do *thumbnail*](http://pt.wikipedia.org/wiki/Thumbnail) exibido.

Além destes atributos, este tipo permite que seja declarada uma lista de *tags* "**mime-type**" internas. Trata-se dos tipos de arquivos (identificados por seu “MIME Type”](http://en.wikipedia.org/wiki/Internet_media_type)) que o campo aceitará. Estes tipos devem ter sido previamente declarados no arquivo de configuração “**configure/archive.xml**”. Caso não seja declarada nenhuma restrição no *field*, ou seja, não haja nehuma *tag* “**mime-type**” interna, o campo aceitará todos os tipos de arquivo habilitados para a instância.

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
