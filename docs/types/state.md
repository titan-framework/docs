---
layout: page
title:  State
subtitle: Representação de unidades federativas.
comments: true
---

O tipo "State", derivado de "Select", já é pré-configurado para relacionar a tabela de estados do Titan (tabela mandatória "_state" do *schema* padrão). Pode ser utilizado sozinho ou em conjunto com o tipo "City" (acima). Para este último caso, ele possui um atributo específico denominado "city-id", que é o identificador (atributo "id") do *field* do tipo "City" que será carregado com as cidades pertencentes ao estado selecionado neste campo.

Uma declaração típica destes campos, utilizados em conjunto, no arquivo XML da seção seria:

{% highlight xml linenos %}
<field type="State" column="state" label="State | pt_BR: Estado" value="MS" city-id="_CITY_" />
<field type="City" column="city" label="City | pt_BR: Município" uf="MS" id="_CITY_" />
{% endhighlight %}
