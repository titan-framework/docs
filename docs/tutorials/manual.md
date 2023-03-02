---
layout: page
title: Manual do Usuário
subtitle: Geração automática do manual do usuário.
comments: true
---

Esta funcionalidade permite a rápida geração do **Manual do Usuário** para a instância facilitando imensamente a criação desta documentação.

Antes de utilizar o gerador, vale a pena se atentar a alguns atributos existentes no XML que permitem a inserção de metadados. O correto preenchimento destes atributos enriquece o conteúdo do manual. Os atributos são os seguintes:

- Na tag **<section />** do '**business.xml**', os atributos '**doc**' e '**description**'.
- Na tag **<action />** do '**config.inc.xml**' de cada pasta de seção, os atributos '**doc**', '**description**' e '**warning**'.
- Na tag **<field />** dos arquivos XML que mapeiam formulários e listas, os atributos '**doc**' e '**help**'.

Em cada uma destas tags o atributo comum '**doc**', quando preenchido, irá gerar conteúdo específico daquela ação, seção ou campo apenas para o manual. O atributo '**description**' irá também gerar conteúdo para o manual, mas também irá mostrar informação adicional quando o cursor do mouse estiver sobre itens de menu. O atributo '**warning**' de ações e '**help**' de _fields_ também irão gerar conteúdo para o manual (além de seu uso convencional).

Além dos metadados nos XMLs da instância, cada componente e tipo do repositório nativo do Titan possui sua própria documentação (genérica, para atender a qualquer que seja o uso do componente/tipo). Portanto, ao se construir um novo tipo ou componente, considere criar também a pasta '**_doc/**' com a documentação padrão para que seja gerado conteúdo no manual referente às seções, ações e campos instanciados a partir daquele componente ou tipo. Como modelo/exemplo, observe o componente "**global.generic**" que possui um diretório '**_doc**' devidamente configurado.

Por exemplo, vamos supor o uso do componente "**global.home**". Este componente é geralmente utilizado como a seção inicial de instâncias do Titan por possibilitar acesso direto à mudança de senha, edição de dados pessoais e ao monitor RSS do sistema, que permite visualizar as mudanças que ocorreram.

Este componente possui uma pasta '**_doc**' e dentro dela há uma série de arquivos:

```bash
.en_US.txt
.es_ES.txt
.pt_BR.txt
home.en_US.txt
home.es_ES.txt
home.pt_BR.txt
personal.en_US.txt
personal.es_ES.txt
personal.pt_BR.txt
profile.en_US.txt
profile.es_ES.txt
profile.pt_BR.txt
```

Os arquivos iniciados com '.' se referem à documentação genérica da seção em cada idioma suportado. Os demais arquivos se referem a cada uma das engines que compõe o componente e, portanto, documentam genericamente ações que as mapeiam. Desta forma, qualquer seção instanciada com o uso do componente "**global.home**" fará uso destes arquivos para gerar o manual.

Seguindo nosso exemplo, vamos observar o '**config.inc.xml**' de uma seção denominada "**home**" que instancia o "**global.home**":

```xml
<action-mapping>
	<action
		name="home"
		label="System Monitor | pt_BR: Monitor do Sistema"
		default="true"
		description="System monitor (RSS Reader). | pt_BR: Monitoramento do sistema (Leitor RSS)."
		warning="Use the right buttons to edit your personal data. | pt_BR: Utilize os botões à direita para editar seus dados pessoais."
		doc="This action is a RSS reader and allows edit your personal data. | pt_BR: Esta ação é um leitor RSS e possibilita que você altere seus dados pessoais.">
		<menu function="search" image="create.png" label="Add RSS Feed | pt_BR: Adicionar Feed RSS" />
		<menu action="profile" image="personal.png" />
	</action>

	<action
		name="profile"
		label="View Personal Data | pt_BR: Visualizar Dados Pessoais"
		description="Description for profile action. | pt_BR: Descrição para a ação de visualizar dados pessoais."
		doc="This action shows your personal data. | pt_BR: Esta ação mostra seus dados pessoais.">
		<menu function="search" image="permission.png" label="Mudar Senha" />
		<menu action="personal" image="edit.png" />
		<menu action="home" image="list.png" />
	</action>

	<action
		name="personal"
		label="Editar Dados Pessoais"
		description="">
		<menu function="search" image="permission.png" label="Mudar Senha" />
	</action>
</action-mapping>
```

No '**configure/business.xml**' a seção esta mapeada por meio da _tag_:

```xml
<section
	label="Home | pt_BR: Página Inicial"
	description="Description for section. | pt_BR: Descrição para uma seção."
	doc="Customizabled documentation for section. | pt_BR: Documentação customizada para uma seção."
	name="home"
	component="global.home"
	default="true"
/>
```

Com estas informações o Titan irá gerar um manual de forma automática, conforme mostrado abaixo:

![](/docs/tutorials/manual/image_0.png)

Onde:

![](/docs/tutorials/manual/image_1.png)

Os menus também serão documentados automaticamente:

![](/docs/tutorials/manual/image_2.png)

E também os formulários

![](/docs/tutorials/manual/image_3.png)

O Titan gera o manual dentro da pasta '**[cache-path]/doc/**'. Após gerado o manual, o Titan não voltará a gerá-lo, portanto, para atualizar o manual após efetuar mudanças em XMLs ou na documentação de componentes é necessário apagar esta pasta e gerar novamente. Perceba também que deve-se apagar o cache do navegador para visualizar de imediato as mudanças.

Reparem que na documentação gerada para o formulário não há referências a tipos de dados. Esta parte ainda está sendo implementada e é por conta disso o gerador ainda está em uma versão _beta_.

Para ativar a geração de manuais na sua instância basta inserir a propriedade '**doc-path**' na tag "**<titan-configuration />**" do '**configure/titan.xml**'. Atenção! O valor deste atributo não deve referenciar o diretório no _cache_ e sim uma nova pasta dentro da sua instância. Por exemplo, vamos supor que você crie uma pasta denominada "**manual/**" na raiz da sua instância, ou seja, no mesmo nível do '**titan.php**'. O atributo no '**titan.xml**' ficaria:

```xml
<titan-configuration
	...
	doc-path="manual/"
	...
	/>
	...
</titan-configuration>
```

Fazendo isto um novo botão irá surgir no menu de acesso rápido:

![](/docs/tutorials/manual/image_4.png)

O diretório referenciado permite que o manual seja totalmente customizado. Para customizar o manual basta copiar da pasta '**[cache-path]/doc/**' os arquivos que deseja customizar (respeitando a estrutura de diretório). A customização é válida para os arquivos "**settings.ini**", "**sort_hints.txt**" e para todos os arquivos contidos na pasta "**input/**".

Desta forma, antes de gerar o manual da instância, o Titan copia e prioriza os arquivos modificados e contidos na pasta apontada pelo atributo "**doc-path**", de tal forma que as customizações do usuário sejam aplicadas na versão final. Para entender como alterar estes arquivos, você deverá estudar a [documentação do TypeFriendly](https://static.invenzzia.org/docs/tf/0_1/single/en/).

Assim, a versão gerada inicialmente pelo Titan pode ser totalmente modificada, criando-se um manual com conteúdo que não pode ser gerado automaticamente, mas sem perder tempo com o conteúdo que pode.
