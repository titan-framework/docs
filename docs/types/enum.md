---
layout: page
title:  Enum
subtitle: Representação de múltipla escolha.
comments: true
---

Utilizado para possibilitar a representação de um campo com opções pré-definidas (menu *drop-down*), das quais o usuário escolhe apenas uma. Repare que os valores aceitos são definidos pelo usuário no momento em que mapeia o campo no XML (não há relacionamento com outra entidade do banco de dados).

Cada valor disponível para seleção deverá ser declarado por meio de uma *tag* interna ao *field* denomida '**item**', que têm os atributos '**value**', que será gravado no banco de dados, e '**label**', que é o rótulo exibido ao usuário:

{% highlight xml linenos %}
<field type="Enum" column="marriage" label="State Civil | pt_BR: Estado Civil">
	<item value="_SINGL_" label="Single (a) | pt_BR: Solteiro(a)" />
	<item value="_MARRI_" label="Casado (a) | pt_BR: Casado(a)" />
	<item value="_DIVOR_" label="Divorced (a) | pt_BR: Divorciado(a)" />
</field>
{% endhighlight %}

Recomenda-se que os valores do atributo 'value' de todos os itens do campo tenham o mesmo tamanho. Desta forma, poderá ser representado no banco de dados pelo tipo '*char*' (com tamanho fixo). Para o exemplo acima ficaria:

{% highlight sql linenos %}
ALTER TABLE titan._user ADD COLUMN marriage CHAR(7);
{% endhighlight %}
