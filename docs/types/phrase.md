---
layout: page
title: Phrase
subtitle: Representação de cadeias de caracteres (*strings*).
comments: true
---

O tipo "Phrase" é a base de diversos outros tipos do *framework*. Seu objetivo é possibilitar a entrada de frases (*strings*). Pode-se setar o tamanho máximo da oração por meio de um atributo específico denominado '**max-length**'. Por exemplo:

{% highlight xml linenos %}
<field
	type="Phrase"
	column="nome_da_coluna"
	label="My Test Field | pt_BR: Meu Campo Teste | es_ES: Meu Campo Teste"
	max-length="256"
/>
{% endhighlight %}

É representado no banco de dados pelo tipo '*character varying*' (usualmente com tamanhos em potência de dois). Por exemplo:

{% highlight sql linenos %}
ALTER TABLE tabela ADD COLUMN coluna VARCHAR(256);
{% endhighlight %}
