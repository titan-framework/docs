---
layout: page
title:  Integer
subtitle: Representação de números inteiros.
comments: true
---

O tipo "Integer" é também a base de diversos outros tipos do *framework*. Seu objetivo é possibilitar a entrada de números inteiros (*integers*). Desta forma, possui uma máscara no campo de entrada permitindo que apenas números inteiros sejam digitados. É representado no banco de dados pelo tipo '*integer*':

{% highlight sql linenos %}
ALTER TABLE tabela ADD COLUMN coluna INTEGER;
{% endhighlight %}
