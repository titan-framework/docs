---
layout: page
title: Arquitetura
subtitle: Principais conceitos arquiteturais.
comments: true
---

Esta seção apresenta uma visão geral da estrutura comum de uma instância do Titan. Observe com atenção a figura abaixo, nela é mostrada a estrutura de arquivos e diretórios de uma instância típica. O arquivo "**titan.php**", na raiz, é o *bootstrap* da aplicação, ele irá carregar o núcleo do Titan a partir do caminho declarado em “**configure/titan.xml**”, o principal arquivo de configuração da instância.

![Estrutura de diretórios e arquivos de uma instância do Titan.](/docs/images/image_3.png)

Uma vez que o núcleo do Titan esteja carregado, ele irá ler o arquivo "**configure/business.xml**", onde estão declaradas todas as seções da instância (cada uma referenciando o componente que irá renderizá-la). O Titan monta o menu de navegação a partir das seções declaradas neste arquivo, levando em consideração as permissões de acesso do usuário. Para saber quais ações a seção terá, o Titan procura dentro da pasta “**section**”, que está na raiz, uma pasta homônima à seção. Uma vez encontrada, ele irá procurar um arquivo chamado “**config.inc.xml**”, que têm a lista de todas as ações disponíveis naquela seção (cada uma referenciando a *engine*, dentro do componente da seção, que irá renderizá-la).

Por exemplo, na instância mostrada na Figura 4 há uma seção denominada "**user**". Quando o usuário acessa esta seção pelo menu da aplicação, o Titan irá carregar as ações declaradas no arquivo “**section/user/config.inc.xml**”.

Na estrutura mostrada, os outros diretórios são:

- **backup:** Local onde serão gravados os arquivos gerados pela funcionalidade de "**_backup on demand_**", um tópico avançado apresentado no “**Cookbook Master Chef**”.
- **cache:** É o diretório (de presença obrigatória) onde o Titan irá gerar uma série de arquivos de *cache* necessários ao funcionamento e otimização de desempenho da instância.
- **configure:** Onde estão os arquivos globais de configuração. Os principais são:
- **titan.xml:** principal arquivo de configuração onde estão dados essenciais à instância, tal como o a configuração do Banco de Dados;
- **business.xml:** onde se declara as instâncias da aplicação e qual componente irá renderizar cada uma;
- **mail.xml:** onde são configurados os e-mails do sistemas, tal como o que é enviado quando o usuário se registra ou quando ele utiliza a opção "Esqueci minha senha";
- **security.xml:** neste arquivo são declarados os 'tipos de usuários' que acessarão o sistema (veja a próxima Seção), para cada tipo deverá haver uma seção homônima que será responsável pela gestão dos usuários daquele tipo cadastrados;
- **type.xml:** neste arquivo o usuário declara os seus tipos locais, ou seja, aqueles que ele implementou para sobrecarregar as funcionalidades dos tipos nativos; e
- **archive.xml:** neste XML são listados todos os tipos de arquivos de *upload* aceitos pelo sistema.
- **doc:** É o diretório onde podem ser colocados arquivos para sobrescrever os criados pela funcionalidade de geração automática de manual de usuário.
- **file:** É o diretório (de presença obrigatória) onde o Titan irá armazenar os arquivos de *upload* do sistema, ou seja, àqueles que foram enviados pelos usuários da aplicação.
- **local:** É o repositório de artefatos local da instância, onde ficará, por exemplo, os tipos e componentes específicos criados pelo desenvolvedor. Não é um diretório de presença obrigatória e deverá ser criado apenas caso existam artefatos específicos e o desenvolvedor queira seguir esta convenção de nome.
- **section:** Conforme explicado, é onde ficam os diretórios com os arquivos XML que parametrizam cada seção da aplicação.
- **update:** Diretório onde são colocados os arquivos para auto-update do Titan.
