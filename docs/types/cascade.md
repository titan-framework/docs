---
layout: page
title:  Cascade
subtitle: Representação de encadeados hierarquicamente.
comments: true
---

O tipo "Cascade" é derivado de "Select". Objetiva vincular tuplas de uma tabela de forma "recursiva", ou seja, representar entidades que possuem chave estrangeira para ela mesma, caracterizando relações de 'tuplas-pais' e 'tuplas-filhas'.

Terá um atributo denominado "**link-father**", que contêm o nome da coluna na tabela relacionada que aponta para a 'tupla-pai'.

Para exemplificar, considere a tabela "organogram.sector" mostrada na Figura 15. Sua coluna "father" é uma chave estrangeira para a chave primária (coluna "id") da própria tabela. O DDL desta entidade é o seguinte:

{% highlight sql linenos %}
CREATE TABLE organogram.sector (
  id SERIAL,
  title VARCHAR(256) NOT NULL,
  father INTEGER,
  _user INTEGER NOT NULL,
  _create TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL,
  _update TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL,
  acronym VARCHAR(32) NOT NULL,
  CONSTRAINT sector_pkey PRIMARY KEY(id),
  CONSTRAINT sector_father_fk FOREIGN KEY (father)
    REFERENCES organogram.sector(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
    NOT DEFERRABLE,
  CONSTRAINT sector_user_fk FOREIGN KEY (_user)
    REFERENCES titan._user(_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
    NOT DEFERRABLE
);
{% endhighlight %}


Assim, um "setor" pode estar (ou não) vinculado a um "setor-pai". Em tabelas com tuplas que irão se relacionar aos setores é inserida uma coluna com uma chave estrangeira para esta tabela:

{% highlight sql linenos %}
ALTER TABLE tabela ADD COLUMN coluna INTEGER;

ALTER TABLE tabela ADD CONSTRAINT coluna_sector_fk FOREIGN KEY (coluna) REFERENCES organogram.sector (id) ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
{% endhighlight %}

Repare que, ao utilizar esta abordagem para representar dados organizados em múltiplos níveis, a chave estrangeira sempre será respeitada independente do nível que está sendo referenciado. Além disso, esta arquitetura permite uma quantidade infinita de níveis na árvore.

Para mapear o tipo nos XMLs:

{% highlight xml linenos %}
<field
	type="Cascade"
	column="coluna"
	label="Setor"
	link-table="organogram.sector"
	link-column="id"
	link-view="title"
	link-father="father"
/>
{% endhighlight %}

Na figura abaixo é mostrado como é visualizado o campo para entrada de dados utilizando este tipo.

![Campo do tipo "Cascade".](/docs/images/image_19.png)
