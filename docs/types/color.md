---
layout: page
title:  Color
subtitle: Representação de cores.
comments: true
---

Este tipo fornece uma interface amigável utilizando paleta de cores em um campo no formulário para vínculo de uma cor à tupla. Útil para a criação de rótulos ou tipos que irão classificar ou organizar outra entidade. Na figura abaixo é mostrado o seu uso.

![Campo de entrada de dados do tipo "Color".](/docs/images/image_12.png)

Para utilizá-lo, deve-se criar na tabela uma coluna do tipo '*char*' de tamanho 6 (seis) onde será guardado a cor no padrão RGB hexadecimal (no exemplo, '2E3CFF'):

{% highlight sql linenos %}
ALTER TABLE tabela ADD COLUMN coluna CHAR(6);
{% endhighlight %}
