---
layout: page
title:  CheckBox
subtitle: Representação de múltiplas opções.
comments: true
---

Utilizado para possibilitar a representação de um campo de caixa de seleção (do inglês, *checkbox*), onde há diversas opções pré-definidas e o usuário escolhe quantas quiser. Repare que, assim como no tipo "Enum", os valores aceitos são definidos pelo usuário no momento em que mapeia o campo no XML e não há relacionamento com outra entidade do banco de dados.

![Campo de entrada de dados do tipo "CheckBox".](/docs/images/image_11.png)

A maior diferença deste tipo em relação ao seu pai, o tipo "Enum", será a estrutura no banco de dados, onde a coluna deverá suportar a múltipla seleção de valores. Considere o exemplo abaixo:

{% highlight xml linenos %}
<field type="CheckBox" column="region" label="Região Geográfica" help="Escolha uma ou mais regiões do país.">
	<item value="_CO_" label="Centro-Oeste" />
	<item value="_NE_" label="Nordeste" />
	<item value="_NO_" label="Norte" />
	<item value="_SE_" label="Sudeste" />
	<item value="_SU_" label="Sul" />
</field>
{% endhighlight %}

A representação gráfica pode ser vista na figura abaixo e a coluna no banco de dados ficaria:

{% highlight sql linenos %}
ALTER TABLE tabela ADD COLUMN region CHAR(4)[];
{% endhighlight %}
