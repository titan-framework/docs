---
layout: page
title:  Cep
subtitle: Representação de CEPs.
comments: true
---

Utilizado para possibilitar a entrada e representação de valores de CEP (número do Código de Endereçamento Postal). É automaticamente aplicada uma máscara para que o número fique no formato '*xx.xxx-xxx*' (onde '*x*' é um dígito). É representado no banco de dados pelo tipo '*char*' de tamanho fixo com 8 (oito) caracteres:

{% highlight sql linenos %}
ALTER TABLE tabela ADD COLUMN coluna CHAR(8);
{% endhighlight %}
