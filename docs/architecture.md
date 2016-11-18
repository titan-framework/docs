---
layout: page
title: Arquitetura
subtitle: Principais conceitos arquiteturais.
comments: true
---

Todas as funcionalidades do Titan são organizadas em um modelo de navegação baseado em "**seções**" e “**ações**”. Uma seção é uma funcionalidade da aplicação, tal como a gestão de notícias de um site. As ações são as atividades atômicas que os usuários podem realizar naquela funcionalidade, tal como criar, editar e visualizar notícias.

As seções e ações do Titan são renderizadas em tempo de execução por meio da parametrização, utilizando XML, de código PHP. Este código de script (*server side*) fica organizado em "**componentes**" e “**motores**” (do inglês, **_engines_**). Assim, cada seção da instância precisa estar relacionada a um componente (que irá renderizá-la) e cada ação desta seção precisa estar relacionada a uma *engine* deste componente. Na figura abaixo é mostrada esta relação.

![Esquema geral da renderização de seções e ações por meio de componentes e *engines*.](/docs/images/image_2.png)

Neste caso, o componente denominado "**global.generic**" recebe um arquivo “**config.inc.xml**”, que possui a definição de todas as ações da seção que está sendo gerada. Para a ação ativa, está sendo utilizado a *engine* denominada “**edit**”, que está sendo parametrizada pelo arquivo “**edit.xml**”. Repare que cada *engine* é formada por até três *scripts* PHP:

- **\[_engine_].prepare.php**: Responsável pela camada de Modelo (do inglês, *Model*), irá carregar os dados das entidades consultando a camada de persistência e fornecê-los à camada de visualização;
- **\[_engine_].php**: Responsável pela camada de Visualização (do inglês, *View*), irá exibir ao usuário os dados das entidades; e
- **\[_engine_].commit.php**: Responsável pela camada de Controle (do inglês, *Controller*), irá processar as requisições validando e salvando dados submetidos na camada de persistência e direcionando o fluxo de controle para a próxima seção e ação.

De forma geral, com esta estrutura o Titan é capaz de gerar, em tempo de execução, todas as seções e ações do sistema. É importante compreender este conceito para acompanhar as próximas etapas deste documento.
