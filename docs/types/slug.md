---
layout: page
title:  Slug
subtitle: Representação de URLs amigáveis.
comments: true
---

Este tipo permite a criação de URLs semânticas](http://en.wikipedia.org/wiki/Semantic_URL) para sites que utilizem instâncias do Titan para a gestão de conteúdo. Basicamente ele permite que seja inserido no item em edição uma "*string*" sem espaços, acentos, letras maiúsculas ou caracteres especiais. Esta "*string*", por sua vez, pode ser utilizada para referenciar o item ao invés do ID numérico (chave-privada). A maior vantagem no uso deste tipo é permitir que ferramentas de busca como o Google ranqueiem](http://pt.wikipedia.org/wiki/PageRank) de forma melhor o conteúdo do site.

Para utilizar deve-se criar na tabela no banco de dados uma coluna VARCHAR com propriedades '**NOT NULL**' e '**UNIQUE**' (fundamental, pois este recurso irá substituir o ID do item na página). No XML ficará:

{% highlight xml linenos %}
<field
	type="Slug"
	column="nome_da_coluna"
	label="URL Amigável"
	required="true"
	unique="true"
	max-lenght="512"
	help="Irá compor a URL do link deste item no site principal."
	base="_ID_DO_FIELD_EM_QUE_SERA_BASEADO_"
/>
{% endhighlight %}

Repare que este tipo possui um atributo específico denominado "**base**". Seu uso não é obrigatório, mas nele pode ser atribuído o ID de outro *field* que o tipo "Slug" utilizará para gerar automaticamente uma proposta de URL amigável.
