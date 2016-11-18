---
layout: page
title: Introdução
subtitle: What the hell is this?
comments: true
---

O Titan é um *framework* para instanciação de Sistemas de Gerenciamento de Conteúdo (do inglês, *Content Management Systems - CMS*), aplicações Web utilizadas para criar, editar, gerenciar e publicar conteúdo de forma consistentemente organizada, permitindo que o mesmo seja modificado, removido e adicionado com facilidade. Foi implementado em [PHP](http://php.net) e utiliza o [PostgreSQL](http://postgresql.org) como banco de dados principal.

Uma das principais características do Titan é possuir um conjunto de código imutável e legado denominado "**núcleo**" (do inglês, **_core_**) que sempre pode ser atualizado, mesmo em produção, garantindo que todas as instâncias permaneçam seguras e confiáveis. Isto é possível graças à uma das principais características do Titan: **o suporte legado permanente**. Ou seja, novas versão do Titan jamais causam incompatibilidade com instâncias legadas.

Outro diferencial importante é sua arquitetura única, com foco em reúso. O Titan possui um repositório de artefatos parametrizáveis (com componentes, tipos de dados, *templates* de código, elementos de *layout*, ferramentas e *drives*). Desta forma, boa parte da programação, tal como a definição de modelos de dados, pode ser feita por meio de linguagem de marcação. Esta característica auxilia muito a manutenção corretiva e  evolutiva de funcionalidades da aplicação.

Como será visto, o Titan pode ser facilmente instanciado gerando um CMS pronto para uso com diversas funcionalidades. Para que o desenvolvedor implemente seus requisitos nesta aplicação Web inicial, ele faz uso dos diversos componentes do Titan ou implementa novos, caso os existentes não atendam. Na figura abaixo é mostrada a tela de *login* padrão do *framework*. Neste exemplo, extraído do sistema [Pandora](http://cloud.cnpgc.embrapa.br/pandora) da [Embrapa](http://embrapa.br), foram ativadas diversas funcionalidades inerentes ao *framework*, tal como o acesso e registro de usuários utilizando redes sociais, a validação de documentos gerados pela instância e a autenticação por LDAP.

![Tela de *login* nativa do *framework* (disponível por padrão para todas as instâncias).](/docs/images/image_0.png)

Na figura abaixo, extraída do mesmo sistema, pode-se observar uma tela do *framework* exibida ao usuário logado. Trata-se, portanto, de uma seção e ação ativa naquele momento. Nesta imagem é possível observar diversos outros elementos do Titan. Por exemplo, na barra superior, do lado esquerdo, está o tipo do usuário logado e os grupos de permissões aos quais ele pertence; na mesma barra, no canto superior direito, está uma coleção de ícones que dão acesso à funcionalidades globais do sistema (página inicial, perfil do usuário, sistema de notificações, idiomas, reporte de problema técnico, *backup*, manual de uso da instância e *logoff*); e, no canto inferior esquerdo encontra-se o nome do usuário logado e o botão de menu, que permite que este usuário navegue pelas demais seções do sistema.

![Típica tela de uma instância (após *login*).](/docs/images/image_1.png)
