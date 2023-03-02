---
layout: page
title:  Email
subtitle: Representação de e-mail.
comments: true
---

Utilizado para possibilitar a entrada e representação de e-mails válidos. No momento em que o usuário digita o e-mail, o valor de entrada é validado (inclusive com a consulta ao provedor do e-mail). Não é, portanto, recomendado o uso deste tipo em instância que não terão acesso permanente à internet. É representado no banco de dados pelo tipo '*character varying*' com 256 caracteres (tamanho máximo de um endereço de e-mail](https://tools.ietf.org/html/rfc5321#section-4.5.3)):

{% highlight sql linenos %}
ALTER TABLE tabela ADD COLUMN coluna VARCHAR(256);
{% endhighlight %}
