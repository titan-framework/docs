---
layout: page
title:  Map
subtitle: Exibição de localidade utilizando o Google Maps.
comments: true
---

Permite que o usuário entre com uma localidade utilizando um mapa renderizado pelo [Google Maps](https://maps.google.com). O usuário pode buscar a localidade por meio de um campo de busca aberto. É representado no banco de dados por uma _array_ do tipo '_numeric_':

{% highlight sql linenos %}
ALTER TABLE tabela ADD COLUMN coluna NUMERIC(16,2)[];
{% endhighlight %}

![Campo do tipo "Map".](/docs/types/map/image_0.png)
