---
layout: page
title:  Select
subtitle: Representação de valor linkado.
comments: true
---

O tipo "Select" e suas derivações são os principais responsáveis pela representação de relacionamentos na instância. O tipo "Select", especificamente, possibilita a representação e associação de valores em relacionamentos do tipo "**um para vários**" ("1 x *n*"). Considere a figura abaixo, nela é mostrada duas tabelas relacionadas no banco de dados. A chave estrangeira da tabela "sector" é a coluna "type", que referencia a chave primária da tabela "type" denominada "id".

![Relacionamento "1 x *n*" que será representado com o uso do tipo "Select".](/docs/images/image_15.jpg)

Este tipo possui os seguintes atributos específicos para possibilitar o mapeamento do relacionamento:

- **link-table:** A tabela que será relacionada;
- **link-column:** A chave primária da tabela relacionada;
- **link-view:** As colunas da tabela relacionada a serem exibidas. Caso queira exibir mais de uma coluna, pode-se formatar uma máscara utilizando os nomes das colunas entre colchetes. Por exemplo, configurar o atributo de um *field* que relaciona a tabela mandatória "_user" com o valor "[_name] ([_email])" exibiria algo como "Camilo Carromeu (camilo@carromeu.com)";
- **link-color:** Caso a entidade relacionada possua um *field* do tipo "Color", pode-se referenciar o nome da coluna dele neste atributo para que, na listagem de tuplas, os valores referenciados sejam exibidos com cor de fundo. O uso deste recurso é mostrado na figura abaixo;

![Listagem de itens da tabela "sector", onde o tipo "Select" foi utilizado para representar os "tipos de setores" (coluna "Tipo" na imagem). Neste caso o atributo "link-color" do *field* aponta para a coluna "color" da tabela relacionada "type".](/docs/images/image_16.png)

- **link-api:** Este atributo será utilizado em instâncias que possuem camadas de serviços ativas (REST-Like API) e utilizem a abordagem de "desambiguação". Este recurso é explicado detalhadamente no "**Cookbook Master Chef**"; e
- **search:** Este atributo permite que seja associado um arquivo XML com a sintaxe de *engine* de listagem ao *field*. Com isso, passa a ser possível efetuar busca no campo, como se faz em uma ação de listagem convencional.

No exemplo, o código XML para a representação do campo seria:

{% highlight xml linenos %}
<field
	type="Select"
	column="type"
	label="Type | pt_BR: Tipo"
	required="true"
	link-table="organogram.type"
	link-column="id"
	link-view="name"
	help="Select the type of sector. | pt_BR: Selecione o tipo do setor."
/>
{% endhighlight %}

![Campo do tipo "Select".](/docs/images/image_17.png)

A renderização é mostrada na Figura 17. Se, por exemplo, quiséssemos utilizar o atributo "search", precisaríamos criar um novo arquivo de marcação para configurar a visualização da busca de itens. Para o exemplo que estamos utilizando, este arquivo poderia ser chamado de "search.xml" e ser colocado na pasta da seção com o seguinte conteúdo:

{% highlight xml linenos %}
<?xml version="1.0" encoding="UTF-8"?>
<view table="organogram.type" primary="id" paginate="15">
	<field type="Phrase" column="name" label="Nome" id="_TITLE_" />
	<field type="Select" column="_user" label="Last Author | pt_BR: Último Autor"
	link-table="_user" link-column="_id" link-view="_name" />
	<order id="_TITLE_" invert="false" />
</view>
<search table="organogram.type">
	<field type="Phrase" column="name" label="Nome" />
</search>
{% endhighlight %}

Neste caso, a renderização do campo contaria com um ícone em formato de lupa, que permite ativar a busca, conforme mostrado na figura abaixo.

![Campo do tipo "Select" com o atributo "search" sendo utilizado.](/docs/images/image_18.png)
