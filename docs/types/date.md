---
layout: page
title:  Date
subtitle: Representação de datas.
comments: true
---

O tipo "Date" é utilizado para possibilitar a entrada e representação de datas. Possui os seguintes atributos específicos:

- **first-year:** Configura o primeiro ano que poderá ser selecionado no campo. Caso não seja especificado, o padrão será 30 anos antes do ano atual. Aceita a palavra-chave "[now]" para determinar que o primeiro ano é o atual;
- **last-year:** Configura o último ano que poderá ser selecionado no campo. Caso não seja especificado, o padrão será 30 anos após o ano atual. Aceita a palavra-chave "[now]" para determinar que o último ano é o atual;
- **show-time:** Está disponível para possibilitar a representação, em um único campo, de valores *timestamp* com data e hora. Aceita os valores 'true' e 'false'. Caso seja especificado com 'true', em ações de visualização será mostrado com a hora ao lado da data. É útil, principalmente, para representar valores gerados automaticamente no banco de dados, como em colunas que recebem, por padrão, o valor do método "now ()"; e
- **show-age:** Aceita os valores 'true' e 'false'. Caso seja especificado com 'true' irá mostrar em ações de visualização, ao lado da data, o tempo em anos decorridos até a data atual.

É representado no banco de dados pelo tipo '*timestamp*' (que pode ser com ou sem *timezone*, dependendo do seu requisito):

{% highlight sql linenos %}
ALTER TABLE tabela ADD COLUMN coluna TIMESTAMP WITHOUT TIME ZONE;
{% endhighlight %}

Abaixo é exibido um exemplo de um campo para preenchimento da "Data de Nascimento" e na figura abaixo é mostrada sua renderização.

{% highlight xml linenos %}
<field
	type="Date"
	column="birth_date"
	label="Birth Date | pt_BR: Data de Nascimento"
	first-year="1900"
	last-year="[now]"
	show-age="true"
/>
{% endhighlight %}


![Campo do tipo "Date".](/docs/images/image_22.png)
