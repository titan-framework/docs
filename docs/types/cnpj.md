---
layout: page
title:  Cnpj
subtitle: Representação de CNPJ.
comments: true
---

Utilizado para possibilitar a entrada e representação de valores de CNPJ (número do Cadastro Nacional de Pessoa Jurídica da Receita Federal). É automaticamente aplicada uma máscara para que o número fique no formato '*xxx*.*xxx*.*xxx*/*xxxx*-*xx*' (onde '*x*' é um dígito). Somente permitirá a entrada de números de CNPJ válidos. É representado no banco de dados pelo tipo '*char*' de tamanho fixo com 15 (quinze) caracteres:

{% highlight sql linenos %}
ALTER TABLE tabela ADD COLUMN coluna CHAR(15);
{% endhighlight %}
