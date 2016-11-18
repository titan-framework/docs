---
layout: page
title:  Double
subtitle: Representação de números decimais.
comments: true
---

O tipo "Double" objetiva possibilitar a entrada de números reais (ponto flutuante). Possui um atributo denominado “**precision**”, onde é declarado o número de casas decimais com que o campo irá trabalhar (por padrão é dois). Possui uma máscara no campo de entrada permitindo que apenas números reais (com a quantidade de casas decimais definida) sejam digitados. É representado no banco de dados pelo tipo '*double precision*':

{% highlight sql linenos %}
ALTER TABLE tabela ADD COLUMN coluna DOUBLE PRECISION DEFAULT 0.0 NOT NULL;
{% endhighlight %}
