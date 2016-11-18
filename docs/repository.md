---
layout: page
title: Repositório Global
subtitle: Repositório de componentes nativos.
comments: true
---

O Titan possui um repositório de ativos próprio, que possui diversos conjuntos de artefatos que podem ser reutilizados para diferentes propósitos. Os artefatos contidos neste repositório global, presente no núcleo do Titan, são denominados **artefatos nativos**. Os dois conjuntos principais, ou seja, os mais importantes para qualquer instância de algum aplicativo construído com o *framework*, são os seguintes:

- [**Componentes**](/docs/components): Um componente, conforme já explicado na página da [arquitetura](/docs/architecture), é o conjunto de *scripts* PHP que é parametrizado para instanciar uma seção. Os componentes nativos do Titan possuem um alto grau de parametrização, permitindo criar seções com comportamento similiar mas com modelos de dados completamente distintos. Para ilustrar, pode-se criar com o componente "**global.generic**" uma seção que gerencia notícias de um portal e uma seção que gerencia informações institucionais relacionadas ao portal, mesmo que não possuam nenhum campo semelhante.

- [**Tipos**](/docs/types): Como o intuito do Titan é instanciar sistemas CMS, normalmente uma seção contém formulários para a criação, visualização, edição e deleção de tuplas das entidades do Banco de Dados. No Titan a camada de dados da aplicação é, em parte, implementada por meio de arquivos XML. Estes arquivos parametrizam classes da API do *framework* instanciando, em tempo de execução, os objetos do modelo de dados (do inglês, *Data Access Object* - DAO). Estes objetos são passados à camada de visualização, permitindo representar os formulários supracitados. Estes XMLs são compostos por uma série de "**campos**" (do inglês, **_fields_**) que, por sua vez, mapeiam um “**tipo**” (do inglês, **_type_**) do *framework*. Os tipos são, portanto, um conjunto de *scripts* PHP que são parametrizados por estas entradas (*tags*) do XML, mapeando os atributos nestes objetos do modelos de dados.
