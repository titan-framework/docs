---
layout: page
title:  Boolean
subtitle: Representação de valores lógicos.
comments: true
---

O tipo "Boolean" têm por objetivo possibilitar a entrada e representação de valores lógicos ou booleanos (*booleans*). Na prática, este campo aceita dois valores: sim ou não.

Por padrão, a representação do tipo em um formulário apresenta uma caixa de seleção (*checkbox*) que pode ser marcada ou desmarcada. Entretanto, o tipo possui também um atributo específico denominado "**question**" que pode ser '*true*' ou '*false*'. Quando o atributo existir na *tag* da *field* e estiver marcado como verdadeiro (*true*), ao invés da caixa de seleção serão mostradas as opções "Sim" e "Não" para que o usuário escolha entre uma delas. Na figura abaixo é mostrada sua representação com este atributo ativo.

![Campo de entrada de dados do tipo "Boolean".](/docs/images/image_13.png)

É representado no banco de dados pelo tipo '*bit*':

{% highlight sql linenos %}
ALTER TABLE tabela ADD COLUMN coluna BIT(1) DEFAULT B'0' NOT NULL;
{% endhighlight %}
