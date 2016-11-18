---
layout: page
title:  Phone
subtitle: Representação de número telefônico.
comments: true
---

Utilizado para possibilitar a entrada e representação de números de telefone. É automaticamente aplicada uma máscara para que o número fique no formato '(*xx*) *xxxx*-*xxxx*' (onde '*x*' é um dígito). É representado no banco de dados pelo tipo '*varchar*' com até 11 (onze) caracteres:

{% highlight sql linenos %}
ALTER TABLE tabela ADD COLUMN coluna VARCHAR(11);
{% endhighlight %}
