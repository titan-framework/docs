---
layout: page
title:  Time
subtitle: Representação de horário.
comments: true
---

O tipo "Time" é utilizado para possibilitar a entrada e representação de hora. É representado no banco de dados pelo tipo '*timestamp*' (que pode ser com ou sem *timezone*, dependendo do seu requisito):

{% highlight sql linenos %}
ALTER TABLE tabela ADD COLUMN coluna TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL;
{% endhighlight %}
