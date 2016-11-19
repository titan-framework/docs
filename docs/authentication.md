---
layout: page
title: Autenticação e Autorização
subtitle: Tipos de usuários, grupos e permissões.
comments: true
---

O Titan permite que sejam configurados, pelo desenvolvedor, diversos "**tipos de usuários**" que ficarão disponíveis na instância. Um "**tipo de usuário**" é a delimitação de um modelo de dados para uma fatia de usuários que acessam o sistema. Assim, caso tenhamos, por exemplo, um sistema de controle acadêmico que será acessado por "professores" e "alunos" podemos esperar que, apesar das entidades que representam cada um destes atores compartilharem diversos campos (tal como "nome" ou "telefone"), haverá campos específicos no perfil de cada um destes atores (tal como "número da matrícula" e "ano" para o aluno e "salário" para o professor). Assim, a instância deverá ter sido configurada pelo desenvolvedor com estes dois tipos de usuários. Repare que a especificação dos tipos de usuários deverá ser feita no desenvolvimento da aplicação, por meio de arquivos de marcação XML. Cada usuário da instância poderá estar associado a apenas um tipo de usuário.

Por padrão, cada ação de cada seção do *framework* possui uma **permissão de acesso**. Para que o usuário visualize no menu uma determinada seção e possa acessá-la, ele deverá ter permissão de uso de pelo menos uma ação naquela seção. É possível alocar as permissões em **grupos** e associar usuários a eles. Ou seja, uma permissão não é associada diretamente ao usuário e sim indiretamente por meio dos grupos aos quais aquele usuário pertence. Na figura abaixo é possível visualizar a tela em que se associa permissões a um determinado **grupo**.

![Associação de permissões à grupos de usuários.](/docs/images/image_4.png)

Por fim, é possível associar aos **tipos de usuários**, quais **grupos** deverão ser associados no momento em que um usuário daquele tipo é cadastrado ou se registra no sistema. Em resumo, os tipos de usuários serão, portanto, responsáveis pelo modelo de dados do usuário, enquanto os grupos estabelecem quais permissões o usuário possui.
