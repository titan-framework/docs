---
layout: page
title:  Collection
subtitle: Representação de coleções de dados.
comments: true
---

O tipo "Collection" objetiva permitir a criação de tuplas *in loco* em tabelas relacionadas à entidade em que o campo deste tipo é inserido, ou seja, permite criar, apagar e exibir elementos vinculados ao formulário em uma relação “**um para vários**” (“1 x *n*”). Desta forma, este tipo irá renderizar para o usuário uma 'sub-lista' dos itens relacionados e um 'sub-formulário' para a criação de novos itens. A definição destes elementos deverá ser feita em um XML próprio, que será referenciado no field por meio do atributo específico denominado “**xml-path**”.

Por exemplo, suponha a seguinte estrutura de tabelas:

{% highlight sql linenos %}
CREATE TABLE public.book (
  id SERIAL,
  name VARCHAR(128) NOT NULL,
  _user INTEGER NOT NULL,
  _create TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL,
  _update TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL,
  CONSTRAINT book_pkey PRIMARY KEY(id),
  CONSTRAINT book_user_fk FOREIGN KEY (_user)
    REFERENCES titan._user(_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
    NOT DEFERRABLE
) WITHOUT OIDS;

CREATE TABLE public.author (
  id SERIAL,
  book INTEGER NOT NULL,
  first_name VARCHAR(64) NOT NULL,
  last_name VARCHAR(64) NOT NULL,
  _create TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL,
  CONSTRAINT author_pkey PRIMARY KEY(id),
  CONSTRAINT author_book_fk FOREIGN KEY (book)
    REFERENCES public.book(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
    NOT DEFERRABLE
) WITHOUT OIDS;
{% endhighlight %}


Repare que na tabela 'author' há uma chave estrangeira para a tabela 'book', formando uma relação "1 x *n*". O “Collection” permitirá que o usuário, no formulário de edição de livros, crie autores que são automaticamente vinculados ao livro editado. O tipo conta, portanto, com um formulário que permite a inserção de autores e uma listagem dos autores inseridos (que permite deletá-los). Assim, é necessário prover a este tipo o modelo de dados deste formulário e desta listagem por meio de um XML próprio, criado na pasta da seção:

{% highlight xml linenos %}
<?xml version="1.0" encoding="UTF-8"?>
<view table="public.author" primary="id">
	<field type="Phrase" column="first_name" label="First Name | pt_BR: Primeiro Nome" />
	<field type="Phrase" column="last_name" label="Last Name | pt_BR: Último Nome" />
</view>
<form table="public.author" primary="id">
	<field type="Phrase" column="first_name" label="First Name | pt_BR: Primeiro Nome"
	max-length="64" required="true" />
	<field type="Phrase" column="last_name" label="Last Name | pt_BR: Último Nome"
	max-length="64" required="true" />
</form>
{% endhighlight %}

Vamos supor que o XML criado acima esteja na pasta da seção de livros com o nome 'author.xml'. Agora, basta inserir o campo no formulário de livros:

{% highlight xml linenos %}
<field type="Collection" id="_AUTHOR_" column="book" xml-path="author.xml" />
{% endhighlight %}

A renderização do campo do exemplo pode ser visualizada na figura abaixo.

![Campo do tipo "Collection".](/docs/images/image_21.png)

Algumas informações importantes sobre o tipo "Collection":

- Somente é possível editar um campo do tipo "Collection" em ações de edição, ou seja, a tupla "mãe" já precisa estar criada para que o “Collection” saiba a qual entidade ele deve relacionar o item criado;
- Como, na prática, são formulários independentes, os campos "Collection" sempre ficarão no final da página de edição, independente do local em que você os colocou no XML. Em ações de visualização a posição escolhida é respeitada; e
- Sempre utilize os mesmos campos na *tag* 'view' e na *tag* 'form' do XML do "Collection". O JavaScript que cria uma nova linha na visualização lida apenas com os campos declarados na *tag* 'form', ou seja, se hoverem números distintos de colunas na 'view' e na 'form' a visualização ficará prejudicada.
