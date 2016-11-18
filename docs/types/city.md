---
layout: page
title:  City
subtitle: Representação de cidades.
comments: true
---

O tipo "City" é derivado de “Select”, com a diferença de que já é configurado para relacionar a tabela de cidades do Titan (tabela mandatória “_city” do *schema* padrão). Também possui um atributo denominado “**uf**”, onde  deve ser especificado qual o estado (unidade federativa) do Brasil do qual serão as cidades listadas. Assim, para trabalhar com este campo, deve-se utilizar este atributo ou utilizá-lo em conjunto com o tipo “State” (abaixo), ou seja, é fundamental que o campo receba o estado ao qual pertencem as cidades exibidas.
