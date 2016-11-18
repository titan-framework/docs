---
layout: page
title: PlainText
subtitle: Representação de textos puros.
comments: true
---

![Campo de entrada de dados do tipo "PlainText".](/docs/images/image_7.png)

O tipo "PlainText", derivado do “Phrase”, objetiva possibilitar a entrada e representação de texto puro (*plain text*). Uma representação da entrada deste tipo de dado pode ser visualizada na figura abaixo. É representado no banco de dados pelo tipo '*text*':

{% highlight sql linenos %}
ALTER TABLE tabela ADD COLUMN coluna TEXT;
{% endhighlight %}
