---
layout: page
title:  Document
subtitle: Geração automática de documentos em PDF.
comments: true
---

O tipo "Document" possui uma complexa estrutura que adiciona às instâncias do Titan a capacidade de gerar e validar documentos PDF. Ele é muito útil para a geração de certificados, termos, contratos ou qualquer tipo de documento que pode ser gerado pela instância a partir de um modelo.

O "modelo" é uma estrutura e um conteúdo padrão para o texto. A estrutura jamais mudará para um tipo de documento específico e definirá quais os campos de conteúdo e o PDF final a ser gerado para este documento. Já o conteúdo padrão deverá ser configurado em uma seção especial instanciada a partir do componente "[global.Simple](/docs/components/simple)" utilizando palavras-chave que serão substituídas pelo Titan.

O componente [global.Simple](/docs/components/simple) é semelhante ao [global.Generic](/docs/components/generic), mas para se trabalhar com uma única tupla (e não com uma tabela). É muito útil para se criar seções de configuração ou gestoras de uma única página rica. Não é necessário fazer alterações no DB para instanciar uma seção do tipo [global.Simple](/docs/components/simple) já que o conteúdo de todas estas seções são salvas na tabela mandatória '_simple'.

Para facilitar a explicação do tipo, vamos supor que eu tenha o seguinte cenário: uma instância que gerencie estagiários. Nela usuários podem se cadastrar por meio de um formulário público e se inscrever em estágios que foram previamente cadastrados. Para cada estagiário deferido eu poderia lançar informações adicionais e, ao final, lançar seu certificado. Para lançar este certificado, bastaria inserir um "<field type="Document" ... />" no formulário em que são lançadas informações específicas da relação "usuário x estágio".

Assim, para utilizar o tipo 'global.Document' precisamos primeiro instanciar uma seção do componente 'global.Simple' onde será configurado o texto padrão do certificado. Por exemplo, vamos considerar o certificado padrão de estágio da [Embrapa](https://embrapa.br) (frente e verso):

![Certificado padrão da Embrapa.](/docs/types/document/image_0.jpg)

Assim, a seção deverá conter campos necessários para caracterizar todos os elementos do certificado. Destacando todos os elementos que eu julguei que devem ser configurados, teríamos:

![image alt text](/docs/types/document/image_1.jpg)

Agora, basta instanciar a seção para edição dos campos definidos. Uma seção do componente global.Simple possui apenas duas ações: uma que mapeia a engine 'view' e outra que mapeia a engine 'edit'. Além disso, ela deve possuir uma diretiva de nome '_ID_' que determina um identificador único para este conteúdo na tabela '\_simple' e, assim, permite sua recuperação posterior. No nosso caso defini este identificador como sendo '\_TRAINEE_CERTIFICATE_':

{% highlight xml linenos %}
<directive name="_ID_" value="_TRAINEE_CERTIFICATE_" />
{% endhighlight %}

Lembro-lhes que utilizaremos esta seção para configurar os textos padrões que preencherão o certificado, entretanto, estes textos deverão ser customizados na geração do certificado. Para isto é necessário definir hashs (ou palavras-chave) que, no momento da geração, serão substituídas por outro valor. Por exemplo:

- **%NOME%** para o nome do indivíduo;
- **%PERIODO%** para o período; e
- **%CARGA_HORARIA%** para carga horária.

O usuário que efetuar o preenchimento do texto padrão poderá dispor destas hashtags. Foi adicionada uma função JS ao componente global.Simple para facilitar a exibição destas hashtags. A função se chama 'viewTags ()' e, na prática, ela abre em uma tabela um arquivo .ini com as hashtags e o que elas significam. Utilizando esta funcionalidade o config.inc.xml da nossa seção ficaria:

{% highlight xml linenos %}
<action-mapping>
	<directive name="_ID_" value="_TRAINEE_CERTIFICATE_" />
	<directive name="_TAG_" value="tag.ini" />
	...
	<action
		name="edit"
		label="Edit | pt_BR: Editar | es_ES: Editar">
		<menu function="js" js="viewTags ()" image="book.png" label="Symbol Substitution | pt_BR: Símbolos de Substituição" />
		<menu function="save" />
		<menu action="view" image="close.png" />
	</action>
	...
	<action
		name="view"
		label="Show | pt_BR: Visualizar | es_ES: Mostrar"
		description=""
		default="true">
		<menu function="js" js="viewTags ()" image="book.png" label="Symbol Substitution | pt_BR: Símbolos de Substituição" />
		<menu function="print" />
		<menu action="edit" />
	</action>
</action-mapping>
{% endhighlight %}

Reparem que o meu arquivo com a lista de hashtags disponíveis se chama tag.ini. A diretiva '_TAG_' diz isso a função viewTags (). O arquivo 'tag.ini' deve, portanto, ser colocado na pasta da seção e, no nosso caso, seu conteúdo seria:

{% highlight bash linenos %}
[Estágio]
%NOME% = "Nome do estagiário"
%PERIODO% = "Período do estágio"
%CARGA_HORARIA% = "Carga horária total do estágio"
{% endhighlight %}

No menu irá aparecer um novo botão que dará  acesso à lista de _hashtags_. Vejam o exemplo abaixo:

![](/docs/types/document/image_2.png)

Para finalizar a seção, o all.xml, mapeando as características do certificado, ficaria:

{% highlight xml linenos %}
<form>
	<go-to flag="success" action="[default]" />
	<go-to flag="fail" action="[same]" />
	<group label="Front | pt_BR: Frente | es_ES: Frente">
		<field type="File" column="background" label="Background Image | pt_BR: Imagem de Fundo | es_ES: Imagen de fondo" id="_BACK_">
			<mime-type>image/jpeg</mime-type>
			<mime-type>image/gif</mime-type>
			<mime-type>image/pjpeg</mime-type>
			<mime-type>image/png</mime-type>
		</field>
		<field type="Text" column="verb" label="Word (Line 1) | pt_BR: Verbo (Linha 1) | es_ES: Palabra (Línea 1)" id="_VERB_" />
		<field type="Text" column="name" label="Name (Line 2) | pt_BR: Nome (Linha 2) | es_ES: Nombre (Línea 2)" id="_NAME_" />
		<field type="Text" column="event_call" label="Call Event (Line 3) | pt_BR: Chamada do Evento (Linha 3) | es_ES: Evento de llamadas (línea 3)" id="_EVENT_CALL_" />
		<field type="Text" column="event" label="Event (Line 4) | pt_BR: Evento (Linha 4) | es_ES: Eventos (Línea 4)" id="_EVENT_" />
		<field type="Text" column="qualifying_call" label="Call Qualifier (Line 5) | pt_BR: Chamada do Qualificador (Linha 5) | es_ES: Calificador de llamadas (Línea 5)" id="_QUALIFYING_CALL_" />
		<field type="Text" column="qualifying" label="Qualifier (Line 6) | pt_BR: Qualificador (Linha 6) | es_ES: Calificador (Línea 6)" id="_QUALIFYING_" />
		<field type="Text" column="period_call" label="Call Period (Linha7) | pt_BR: Chamada do Período (Linha7) | es_ES: Periodo de Llamadas (Linha7)" id="_PERIOD_CALL_" />
		<field type="Text" column="period" label="Period (Line 8) | pt_BR: Período (Linha 8) | es_ES: Periodo (línea 8)" id="_PERIOD_" />
	</group>
	<group label="Verse | pt_BR: Verso | es_ES: El versículo">
		<field type="String" column="header" label="Header | pt_BR: Cabeçalho | es_ES: Cabecera" id="_HEADER_" />
		<field type="Text" column="register" label="Registration | pt_BR: Registro | es_ES: Registro" id="_REGISTER_" />
		<field type="Text" column="assign_1" label="Signature 1 | pt_BR: Assinatura 1 | es_ES: Firma un" id="_ASSIGN_1_" />
		<field type="Text" column="assign_2" label="Signature 2 | pt_BR: Assinatura 2 | es_ES: Firma 2" id="_ASSIGN_2_" />
		<field type="String" column="activity_header" label="Header for Activities | pt_BR: Cabeçalho para as Atividades | es_ES: Encabezado de Actividades" id="_ACTIVITY_HEADER_" />
	</group>
</form>
{% endhighlight %}

Reparem que foi colocado um ID específico em cada **<field />**. Isto será importante para trabalharmos mais tarde com seu conteúdo.

A partir deste momento, bastaria referenciar a seção no 'configure/business.xml' e utilizá-la preenchendo os os campos com o texto padrão e utilizando as hashtags especificadas.

Até aqui não entramos no tipo propriamente dito. Apenas preparamos o modelo (conteúdo) que o tipo mais tarde utilizará como base.

O próximo passo é a definição da estrutura do PDF que será gerado para o documento. O tipo 'global.Document' utiliza a biblioteca FPDF para geração do documento final. Esta biblioteca dispõe de uma API em PHP cujo a documentação pode ser vista no link: [https://www.fpdf.org/](https://www.fpdf.org/)

Como cada documento pode variar MUITO em relação a seu layout, decidi trabalhar com um esquema de templates que utilizam diretamente a API do FPDF. Um template de documento é uma dupla de arquivos homônimos: um XML e um PHP. Estes arquivos podem estar em qualquer diretório da instância (por padrão, em 'local/document/').

O arquivo XML do template será uma cópia do all.xml da nossa seção simple (mostrado acima).

O arquivo PHP definirá o formato do PDF em si. Voltaremos a falar sobre como construir este arquivo mais adiante. Por enquanto vale apenas citar que há alguns templates já criados na pasta '[repos]/type/global.Document/template/' que podem auxiliar bastante.

Partindo da suposição que o template tenha sido criado, vamos, ao próximo passo: a utilização do tipo em um formulário qualquer. A idéia básica é que qualquer entidade da sua instância pode estar vinculada a uma coleção de documentos. No nosso exemplo, vamos supor que tenhamos, além do certificado final, um TERMO DE COMPROMISSO. Assim, a definição do nosso tipo seria:

{% highlight xml linenos %}
<field type="Document" column="document" relation="trainee.trainee_doc" link-table="trainee.v_doc" link-column="id">
	<doc id="_COMPROMISE_" template="local/document/compromise" auto="true" validate="true" label="Termo de Compromisso de Estágio Obrigatório" simple="_TRAINEE_COMPROMISE_" />
	<doc id="_CERTIFICATE_" template="local/document/certificate" validate="true" label="Certificado" simple="_TRAINEE_CERTIFICATE_" />
	<replace tag="%NOME%" column="name" />
	<replace tag="%PERIODO%" column="period" />
	<replace tag="%CARGA_HORARIA%" column="workload" />
</field>
{% endhighlight %}

A propriedade 'column' deve conter qualquer valor único. A 'relation' é o nome da tabela que conterá os documentos. A 'link-table' referencia uma visão que possui os dados que serão substituídos no momento da geração do documento. O 'link-column' referencia uma coluna nesta visão que terá o mesmo valor da primary key da tabela do formulário em que o tipo está inserido.

As tags **<doc />** definem cada documento disponível no tipo. A sua propriedade 'id' deve ser uma string única. A 'template' é o caminho para o template (repare que 'local/document/certificate' não é um diretório e sim a parte homônima dos dois arquivos que definem o template), caso não seja um caminho, o Titan irá procurar estes arquivos na pasta '[repos]/type/global.Document/template/'. A propriedade 'validate' define se o documento, após gerado, poderá ser validado pelo mecanismo público de autenticação. A tag 'simple' é o ID do modelo, definido na seção do componente 'global.Simple'.

A tabela que conterá os documentos gerados, apontada pelo atributo 'relation' deverá possuir o seguinte formato no DB:

{% highlight sql linenos %}
CREATE TABLE trainee.trainee_doc (
  _id VARCHAR(64) NOT NULL,
  _relation INTEGER NOT NULL,
  _version INTEGER DEFAULT 1 NOT NULL,
  _content TEXT NOT NULL,
  _file INTEGER DEFAULT nextval('titan._document'::text::regclass) NOT NULL,
  _hash CHAR(32),
  _create TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  _user INTEGER,
  _auth CHAR(16),
  _validate BIT(1) DEFAULT B'0'::"bit" NOT NULL,
  CONSTRAINT trainee_doc__file_key UNIQUE(_file),
  CONSTRAINT trainee_doc_idx PRIMARY KEY(_id, _version, _relation),
  CONSTRAINT trainee_doc_relation_fk FOREIGN KEY (_relation)
    REFERENCES trainee.trainee(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
    NOT DEFERRABLE,
  CONSTRAINT trainee_doc_user_fk FOREIGN KEY (_user)
    REFERENCES titan._user(_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
    NOT DEFERRABLE
);
{% endhighlight %}

Todas as colunas são mandatórias (devem existir e com estes nomes). Reparem que a coluna '_relation' aponta para a "tabela pai" e, portanto, sua constrain deve ser alterada de acordo. No exemplo podemos ver que a tabela de documentos e sua tabela pai pertencem a um esquema denominada 'trainee'. É importante salientar que cada vez que a "tabela pai" mudar, deverá ser feita uma nova tabela de coleção de documentos.

É muito importante se atentar à coluna '_file'. Esta coluna irá guardar um número único para o documento. Lembrem-se que podem existir N tabelas de documentos espalhadas pelo DB. Desta forma, é necessário que todas utilizem a mesma sequência nesta coluna. Esta sequência DEVE existir no esquema padrão da instância (onde ficam as tabelas mandatórias do Titan) e DEVE se chamar '_document'.

Se estiver tudo OK o Titan irá gerar um novo tipo no formulário, conforme pode ser visto abaixo:

![](/docs/types/document/image_3.png)

O processo de geração funciona da seguinte forma:

1. O usuário clica no símbolo '+';
2. Escolhe entre os diversos documentos que aparecem;
3. O Titan carrega o conteúdo definido no simple trocando os valores das hashtags por valores da coluna correspondente na visão e mostra o formulário carregado ao usuário;
4. O usuário edita as informações processadas; e
5. O usuário salva o formulário gerando o documento.

![](/docs/types/document/image_4.jpg)

Toda vez que um novo arquivo do mesmo tipo é gerado, ele entra como uma nova versão daquele arquivo. Na visualização do formulário apenas a última versão será mostrada:

![](/docs/types/document/image_5.png)

Desta forma, versões anteriores de um documento jamais são sobreescritas, mantendo-se o histórico de alterações.

Caso o atributo 'auto' da tag **<doc />** na declaração do tipo tenha sido setado para 'true', ao abrir o formulário pela primeira vez (para edição ou visualização) uma primeira versão do formulário será automaticamente gerada pelo Titan (desprezando-se o passo 4 do processo).

Ao clicar no ícone do PDF o documento é mostrado. Na prática, apenas ao se clicar a primeira vez neste ícone o documento será gerado em PDF.

Agora, com mais informações, vamos retornar um pouco e voltar a falar do template. O script de geração de PDF irá incluir o arquivo PHP do template. Para montar o template, o script de geração disponibiliza algumas variáveis que podemos fazer uso. São elas:

- **$_label** - Com o nome do documento.
- **$_file** - Com o valor da coluna _file, ou seja, um ID único em toda a instância para este documento.
- **$_version** - Com a versão do documento.
- **$_create** - Com a data (formatada) da criação do documento (reparem que ela pode ser diferente da geração do PDF).
- **$_hash** - Com uma hash que é utilizada para gerar a autenticação do documento.
- **$_validate** - Se o documento terá suporte à autenticação pública.
- **$_qr** - Caminho para uma imagem QR Code única para o documento que permite sua autenticação.
- **$_doc** - Com um objeto da classe Form carregado com os dados do XML do template. Desta forma, torna-se bastante simples recuperar o conteúdo do documento. Por exemplo, para pegar o valor do cabeçalho do verso do certificado bastaria fazer:

{% highlight php linenos %}
Form::toText ($_doc->getField ('_HEADER_'));
{% endhighlight %}

É necessário fazer uso do método estático 'toText' da classe Form para garantir que os elementos HTML sejam transformados em caracteres mais apropriados para o PDF.

Vamos agora para a última parte: a autenticação do documento.

Somente documentos com o atributo 'validate' da tag **<doc />** na definição do tipo setado para 'true' poderão ser validados. O Titan permite a autenticação de documentos por meio da combinação de dois valores: o conteúdo da variável $_file (denominado "Número de Controle") e um valor normatizado da variável $_hash (denominado "Autenticação"). Estes valores devem ser impressos no seu documento (é importante sempre imprimí-los, mesmo para os que não possuem autenticação pública). Se observarem os templates que implementei, verão que sempre coloco no rodapé o Número de Controle, a Autenticação e a Versão (bem como a data/hora de criação).

A autenticação "normatizada" nada mais é do que uma compactação da hashing de 32 caracteres hexadecimal presente na variável $_hash para uma de 16 alfanumérica. Isto pode ser obtido com a função:

{% highlight php linenos %}
Document::genAuth ($_hash);
{% endhighlight %}

Também dispomos, na implementação do template, de um QR Code que podemos inserir no documento (a variável $_qr possui o caminho para a figura). Assim, no nosso exemplo, um certificado publicamente autenticável teria no rodapé de seu verso o seguinte conteúdo:

![](/docs/types/document/image_6.jpg)

O documento poderá ser autenticado de duas maneiras. A primeira é por meio de um leitor de QR Code em um celular. Na prática, o QR Code impresso no documento possui um link para o script de autenticação. Assim, qualquer leitor, de qualquer SO (Android, iOS, Symbian, etc), consegue identificá-lo e abrir o link.

A segunda maneira é por meio da tela de logon padrão do Titan. Caso exista a sequência '_document' no esquema padrão da instância, a tela de logon irá apresentar dois novos botões para autenticação de documentos:

![](/docs/types/document/image_7.png)

O primeiro nada mais é que um leitor de QR Code que funcionará de maneira semelhante ao leitor do celular. O segundo é para entrada do Número de Controle e da Autênticação de forma manual.

![](/docs/types/document/image_8.png)

Ambos fazem chamada a um mesmo script de autenticação. Na prática este script verifica se o Número de Controle e a Autenticação existem em alguma das tabelas de documentos. Caso exista, ele verifica se é última versão do documento e informa o usuário. Ele sempre disponibiliza um link para a última versão apenas, para que o próprio usuário possa comparar os documentos (seguindo o modelo de comprovante de votação do TRE).

![](/docs/types/document/image_9.png)
