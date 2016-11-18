---
layout: page
title:  Multiply
subtitle: Representação de campo multivalorado.
comments: true
---

Este tipo é muito semelhante ao "Select" mas, ao invés de representar uma relação “um para vários” (“1 x *n*”), possibilitará a representação de uma relação “**vários para vários**” (“*n* x *n*”). Para utilizá-lo será necessário criar no banco de dados uma tabela de relacionamento, ou seja, a tabela que irá fazer a relação “*n* x *n*” das tuplas de duas outras tabelas. Para abrigar a declaração desta tabela, este tipo possui os seguintes atributos específicos

- **relation: **O nome da tabela de relacionamento;
- **primary:** É o nome da chave primária da tabela mapeada pelo XML e deve ser preenchido quando o *field* estiver sendo utilizado em uma *tag* "search", ou seja, em um formulário de busca;
- **check-box:** Aceita 'true' ou 'false' e determina se a exibição do campo deve ser feita no formato de caixas de marcação (*checkbox*) ao invés de um menu *drop down*; e
- **relation-link:** Por padrão o Titan irá considerar que os nomes das colunas na tabela de relacionamento serão os mesmos das tabelas que eles relacionam. Isto, entretanto, nem sempre será verdade. Este atributo possibilita especificar o nome da coluna na tabela de relacionamento.

Para exemplificar, vamos supor que haja uma tabela 'filme' e outra tabela 'gênero'. Um filme pode estar associado a diversos gêneros e um gênero pode estar classificando diversos filmes. Neste caso, as tabelas a serem criadas serão:

{% highlight sql linenos %}
CREATE TABLE store.movie (
  id SERIAL,
  title VARCHAR(256) NOT NULL,
  description TEXT,
  _user INTEGER NOT NULL,
  _create TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL,
  _update TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL,
  CONSTRAINT movie_pkey PRIMARY KEY(id),
  CONSTRAINT movie_user_fk FOREIGN KEY (_user) REFERENCES titan._user(_id)
  ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE
);

CREATE TABLE store.genre (
  id SERIAL,
  name VARCHAR(256) NOT NULL,
  _user INTEGER NOT NULL,
  _create TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL,
  _update TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL,
  CONSTRAINT genre_pkey PRIMARY KEY(id),
  CONSTRAINT genre_user_fk FOREIGN KEY (_user) REFERENCES titan._user(_id)
  ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE
);

CREATE TABLE store.movie_genre (
  movie INTEGER,
  genre INTEGER,
  CONSTRAINT movie_genre_pkey PRIMARY KEY(movie, genre),
  CONSTRAINT movie_fk FOREIGN KEY (movie) REFERENCES store.movie(id)
  ON DELETE CASCADE ON UPDATE CASCADE NOT DEFERRABLE,
  CONSTRAINT genre_fk FOREIGN KEY (genre) REFERENCES store.genre(id)
  ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE
);
{% endhighlight %}


O resultado da execução dos SQLs acima é a estrutura mostrada na figura abaixo.

![Relacionamento "*n* x *n*" que será representado com o uso do tipo “Multiply”.](/docs/images/image_20.jpg)

No exemplo, vamos considerar que o 'gênero' é uma caracterização do 'filme'. Assim, quando um filme é cadastrado são vinculados gêneros a ele. Haverá, portanto, uma diferença sutil nas chaves estrangeiras da tabela "movie_genre". Repare que quando um gênero é apagado, há uma restrição caso este gênero esteja vinculado a algum filme. Entretanto, no caso de um filme ser apagado, todas as ligações deste filme com gêneros são apagados em cascata.

Da mesma forma, a declaração do campo do tipo "Multiply" será feita no formulário de edição do filme:

{% highlight xml linenos %}
<?xml version="1.0" encoding="UTF-8"?>
<form table="store.movie" primary="id">
...
<field type="Multiply" column="movie_genre" label="Gêneros" link-table="genre" link-column="id" link-view="name" relation="store.movie_genre" />
...
</form>
{% endhighlight %}
