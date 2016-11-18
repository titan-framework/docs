---
layout: page
title: Fck
subtitle: Representação de textos ricos (multimídia).
comments: true
---

![Campo de entrada de dados do tipo "Fck".](/docs/images/image_8.png)

Utilizado para possibilitar a entrada e representação de texto com formatação HTML. Oferece ao usuário um editor de textos que possibilita formatar o conteúdo de forma amigável (um editor [WYSIWYG](http://pt.wikipedia.org/wiki/WYSIWYG)). Uma representação da entrada deste tipo de dado pode ser visualizada na figura abaixo. É representado no banco de dados pelo tipo '*text*':

{% highlight sql linenos %}
ALTER TABLE tabela ADD COLUMN coluna TEXT;
{% endhighlight %}
