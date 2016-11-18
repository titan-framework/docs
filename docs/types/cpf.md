---
layout: page
title:  Cpf
subtitle: Representação de CPF.
comments: true
---

Utilizado para possibilitar a entrada e representação de valores de CPF (número do Cadastro de Pessoa Física da Receita Federal). É automaticamente aplicada uma máscara para que o número fique no formato '*xxx*.*xxx*.*xxx*-*xx*' (onde '*x*' é um dígito). Somente permitirá a entrada de números de CPF válidos. É representado no banco de dados pelo tipo '*char*' de tamanho fixo com 11 (onze) caracteres:

{% highlight sql linenos %}
ALTER TABLE tabela ADD COLUMN coluna CHAR(11);
{% endhighlight %}
