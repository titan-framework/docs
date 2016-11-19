---
layout: page
title:  Url
subtitle: Representação de URL.
comments: true
---

Utilizado para possibilitar a entrada e representação de URLs. Possui um atributo específico, denominado '**prefix**' que pode ser setado com um prefixo obrigatório para as URLs inseridas.

Por exemplo, na figura abaixo é mostrado o uso deste campo para que o usuário possa entrar com a URL para seu currículo na [Plataforma Lattes](http://lattes.cnpq.br). Neste caso o atributo 'prefix' foi atribuído com "http://lattes.cnpq.br/". É importante notar que, neste caso, o atributo '**max-length**', herdado de "Phrase", foi preenchido com o valor '38', ou seja, o tamanho do conteúdo de 'prefix' somado ao tamanho máximo da entrada do usuário.

![Campo de entrada de dados do tipo "Url".](/docs/images/image_9.png)

O mapeamento deste tipo no formulário é mostrado abaixo:

{% highlight xml linenos %}
<field
	type="Url"
	column="lattes"
	label="URL"
	max-length="38"
	prefix="http://lattes.cnpq.br/"
	unique="true"
/>
{% endhighlight %}

É representado no banco de dados pelo tipo '*character varying*'. Para o exemplo acima ficaria:

{% highlight sql linenos %}
ALTER TABLE titan._user ADD COLUMN lattes VARCHAR(38) UNIQUE;
{% endhighlight %}
