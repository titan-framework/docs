---
layout: page
title: API REST-Like
subtitle: Barramento de serviços do Titan.
comments: true
---

A **REST-Like API** do Titan, como não poderia deixar de ser, segue os princípios arquiteturais básicos de REST, implementando uma camada de comunicação simples baseada no protocolo HTTP puro. Assim, esta é uma camada de comunicação cliente/servidor sem estado (*stateless*), e dispõe das operações HTTP básicas (**POST**, **GET**, **PUT** e **DELETE**) permitindo a obtenção de conteúdo a partir de serviços (**URI**) em texto puro (**JSON**). Há uma vasta documentação sobre os princípios inerentes a interfaces REST disponíveis na Web.

A implementação desta camada no Titan utiliza, inicialmente, o padrão [**Embrapa-Auth**](https://cloud.cnpgc.embrapa.br/embrapa-auth) para autenticação. Conforme já citado, por seguir diretrizes arquiteturais REST, trata-se de uma camada sem estado (*stateless protocol*). Por conta disso, **cada requisição precisa ser individualmente autenticada na instância**.

Para auxiliar na compreensão do uso da REST-Like API, foi [disponibilizada uma instância-exemplo do Titan que a utiliza](https://github.com/titan-framework/sample-api). Nesta instância há uma seção CRUD básica (Menu &raquo; Testes &raquo; CRUD), com um formulário com diversos campos. Esta seção permite simular o comportamento de diversos tipos de dados do Titan na REST-Like API. Para testar a comunicação com a instância, foi disponibilizado também um teste unitário em Java (pasta "**test**" na raiz da instância).

Repare que é uma instância simples do *framework*. Nela foi habilitado o [suporte à registro e autenticação por meio do Google+](/docs/tutorials/social-networks), dispensando a tela de autenticação padrão. Assim, para utilizar a instância-exemplo você precisará registrar a aplicação no [**Google APIs**](https://console.developers.google.com).

Para habilitar o uso da REST-Like API nesta instância foi adicionado o seguinte trecho no "**configure/titan.xml**":

```xml
<api xml-path="configure/api.xml" />
```

E foi, em seguida, criado o arquivo "**configure/api.xml**" com o seguinte conteúdo:

{% highlight xml linenos %}
<?xml version="1.0" encoding="UTF-8"?>
<api-mapping>
	<application
		name="mobile"
		auth="APP|CLIENT-AS-USER"
		token="mnOTyIPfrpkMh8w1qDFOl9VvHii4XoZedFUgTxrQqmB7zuPS6CXH1hKsz0ilGgdf"
		request-timeout="36000"
		protocol="Embrapa"
		gcm-api-key=""
		send-alerts="false"
	/>
</api-mapping>
{% endhighlight %}

Reparem que este arquivo possibilita diversas tags '**application**', de forma que pode-se habilitar diferentes aplicações que se comunicarão com a instância. O atributo '**protocol**' refere-se ao padrão de autenticação utilizado. Conforme já dito, até o momento o único padrão implementado no Titan é o [Embrapa-Auth](https://cloud.cnpgc.embrapa.br/embrapa-auth), portanto, é importante que você tenha lido e compreendido este padrão.

Conforme definido no Embrapa-Auth, é possível efetuar a autenticação da requisição de três maneiras (que podem ser combinadas): **aplicação**, **cliente** e **usuário**. O atributo '**auth**' define estas combinações. Assim, o Titan aceita os seguintes valores para este atributo:

- **APP**: autenticação da aplicação por meio de um nome e um *token* fixo que não varia (que têm o mesmo valor do atributo '**token**' definido na tag '**application**');
- **CLIENT**: autenticação do cliente por meio de um identificador e uma chave-privada;
- **CLIENT-AS-USER**: autenticação do usuário utilizando credenciais de um cliente, ou seja, um identificador e uma chave-privada de dispositivo (usável quando o dispositivo é pessoal);
- **USER**: autenticação do usuário por meio de login e senha;
- **USER-BY-ID**: autenticação do usuário por meio de seu identificador e senha; e
- **USER-BY-MAIL**: autenticação do usuário por meio de seu e-mail e senha (somente quando a coluna '_email' é 'unique' na tabela '_user' da instância).

Desta forma, combina-se estas constantes para relatar à instância como virão os cabeçalhos que autenticarão as requisições. No caso da nossa instância-exemplo, o atributo '**auth**' possui o valor "**APP\|CLIENT-AS-USER**". Isto significa que cada requisição será autenticada primeiro pela aplicação (usando o nome e o *token*) e, em seguida, o usuário será reconhecido pelas credenciais do cliente. Quando se utiliza a autenticação "**CLIENT-AS-USER**" assume-se que cada usuário da instância têm seus próprios dispositivos registrados, de forma que aquele (o usuário) pode ser identificado por estes (os dispositivos). Quando do uso deste método, é necessário criar no Titan uma tabela que permite ao usuário registrar seus dispositivos:

{% highlight sql linenos %}
CREATE TABLE _mobile (
  _id SERIAL,
  _pk CHAR(16) NOT NULL,
  _user INTEGER NOT NULL,
  _create TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL,
  _update TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL,
  _name VARCHAR(128) NOT NULL,
  _access TIMESTAMP WITH TIME ZONE,
  _counter INTEGER DEFAULT 0 NOT NULL,
  _gcm VARCHAR(4096),
  CONSTRAINT _mobile_pkey PRIMARY KEY(_id),
  CONSTRAINT _mobile_user_fk FOREIGN KEY (_user)
    REFERENCES _user(_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
    NOT DEFERRABLE
);
{% endhighlight %}

Em novas instâncias, criadas a partir do [Composer](https://getcomposer.org), esta tabela já é criada por padrão.

Além disso, para permitir que o usuário registre seus dispositivos, o componente "**global.home**" do CORE do Titan foi alterado. No "**config.inc.xml**" das seções que instanciam este componente deve-se adicionar as seguintes linhas que ativam a gestão de dispositivos para o usuário:

{% highlight xml linenos %}
<?xml version="1.0" encoding="UTF-8"?>
<action-mapping>
	<directive name="_NEED_UPDATE_AFTER_DAYS_" value="0" />

	<action
		name="profile"
		label="Dados Pessoais"
		default="true">
		<menu function="js" js="showMobileDevices ()" image="mobile.png" label="Mobile Devices | pt_BR: Dispositivos Móveis" />
		<menu action="personal" image="edit.png" />
	</action>

	<action
		name="personal"
		label="Editar Dados Pessoais">
		<menu function="js" js="showMobileDevices ()" image="mobile.png" label="Mobile Devices | pt_BR: Dispositivos Móveis" />
	</action>
</action-mapping>
{% endhighlight %}

Isto fará com que um novo botão seja disponibilizado na interface da seção, provendo acesso à inclusão e remoção de dispositivos pessoais:

![](/docs/images/api/image_0.png)

Para cada dispositivo, é possível obter o identificador e chave-privada do cliente registrado por meio de um **QR Code**:

![](/docs/images/api/image_1.png)

Em relação aos serviços da camada que podem ser acessados, a REST-Like API dispões de URIs pré-definidas (pertencentes ao CORE) e provê ao desenvolvedor a capacidade de criar suas próprias URIs em componentes e seções específicas.

As URIs pré-definidas são acessíveis pela adição do sufixo "api" à URL da instância, seguido do nome do serviço. Por exemplo, "https://seu-host.com/instância/api/disambiguation".

A seguir, são listados os serviços (*endpoints*) nativos do Titan e a explicação de como ativar seus próprios serviços ém seções específicas.

## Serviços Nativos

### GET https://seu-host.com/instância/api/*auth*

Este serviço verifica as credenciais de acesso da requisição, retornando o *HTTP status code* "**200**" em caso de sucesso. Caso esteja autenticando o usuário (por meio dos métodos CLIENT-AS-USER, USER, USER-BY-ID e USER-BY-MAIL), este serviço também retorna os dados do usuário em formato JSON:

```json
{
    "id": 9,
    "login": "camilo",
    "name": "Camilo Carromeu",
    "mail": "camilo@carromeu.com",
    "type": "manager",
    "language": "pt_BR",
    "timezone": "America/Campo_Grande"
}
```

### POST ou PUT https://seu-host.com/instância/api/*register*

Em se tratando de dispositivos móveis com sistema operacional Android, é possível afirmar que o usuário do aplicativo têm, necessariamente, uma conta do Google. Sem ela, a menos que a distribuição do aplicativo seja feita pelo seu binário (APK), o usuário não poderia tê-lo obtido, afinal, a conta do Google é necessária para o acesso ao Google Play.

Esta certeza gera a situação, bastante interessante, de podermos contar no aplicativo com o acesso à conta local de usuário (Google Account) para fazer o registro do usuário no sistema. A maior vantagem desta abordagem é oferecer uma forma de registro ao usuário extremamente simplificada e rápida, sem a exigência do preenchimento de formulários enfadonhos. Para se registrar o usuário precisa apenas escolher uma das contas do Google previamente sincronizadas no dispositivo.

![](/docs/images/api/image_2.png)

Desta forma, este serviço permite registrar um usuário na instância do Titan utilizando a API do Google+. Para isto, este método recebe o e-mail do usuário e um *token* de acesso a uma Google Account. Este *token* vem criptografado (utilizando Blowfish), sendo a chave privada desta criptografia o *token* da autenticação da aplicação no Embrapa-Auth.

Para que este serviço funcione **é necessário que o suporte ao logon por meio do Google+ esteja ativo na instância**, por conta disso este recurso foi habilitado na instância-exemplo (veja a descrição detalhada deste recurso no link postado acima).

![](/docs/images/api/image_3.png)

Futuramente, esta URI permitirá também o registro com o uso da API da Apple (Apple ID) para sistemas iOS.

### POST ou PUT https://seu-host.com/instância/api/*disambiguation*

Outro ponto fundamental no desenvolvimento de aplicativos móveis é garantir a integridade dos dados locais em relação aos do servidor remoto. É fácil garantir esta integridade quando não existe criação de tuplas no dispositivo móvel. Nestes casos, o aplicativo assume uma arquitetura "provedor-consumidor", onde o servidor será o provedor de dados e o aplicativo irá apenas "consumí-los". Desta forma, o controle da sincronia de dados deverá ser responsável por consultar o servidor e obter as novas tuplas e aquelas que já existiam, mas foram alteradas. A abordagem utilizada neste caso têm os seguintes passos:

1. O servidor é consultado passando-se o *timestamp* da última atualização (caso seja a primeira vez, é passado zero);
2. É obtido um JSON com as tuplas e o *timestamp* do servidor (que vêm na requisição HTTP);
3. Este JSON é percorrido, inserindo-se as tuplas que não existem e atualizando as existentes; e
4. Caso tenha tudo corrido com sucesso, o *timestamp* de controle é sobrescrito pelo novo.

Repare que quase todos os softwares implementados terão entidades que serão tratadas em uma arquitetura provedor-consumidor, é o caso, por exemplo, de entidades de metadados (p.e., uma tabela de categorias ou a tabela de cidades do Titan). Assim, a abordagem descrita, que possui uma implementação mais simples do que a comunicação de duas vias, pode ser sempre utilizada.

Quando imaginamos uma entidade que será sincronizada no aplicativo e que pode ser criada e modificada neste, a coisa complica um pouco. Neste caso, se a entidade tiver uma chave natural, podemos utilizá-la para controlar a sincronia. Podemos imaginar, por exemplo, uma entidade '**pessoa**' que tenha uma coluna de preenchimento obrigatório e valores únicos denominada '**cpf**'. Neste caso, nosso fluxo de controle ficaria:

1. A tarefa de sincronia varre as tuplas locais buscando todas aquelas que foram criadas ou modificadas após o *timestamp* da última sincronia de dados (caso seja a primeira vez, são enviadas todas);
2. Conforme veremos, estas tuplas são enviadas pelos métodos POST ou PUT. O servidor verifica, por meio da chave primária natural, se a tupla já existe localmente. Caso não exista, ele a cria e, caso exista, verifica se deve ou não atualizá-la (considerando a mais recente);
3. O servidor é então consultado passando-se o *timestamp* da última sincronia (caso seja a primeira vez, é passado zero);
4. É obtido um JSON com as tuplas e o *timestamp* do servidor (que vêm na requisição HTTP);
5. Este JSON é percorrido, inserindo-se as tuplas que não existem e atualizando as existentes (desde que mais recente que a existente localmente); e
6. Caso tenha tudo corrido com sucesso, o *timestamp* de controle é sobrescrito pelo novo.

Com isso o servidor e a aplicação ficam sincronizados. Repare, no entanto, que podem existir problemas caso o *timestamp* do servidor seja muito diferente que o do aplicativo. Por conta disso, a REST-Like API do Titan exige que o relógio do dispositivo esteja corretamente configurado (emitindo um erro caso isto não ocorra).

No fluxo acima, comparamos as tuplas utilizando a chave natural '**cpf**'. Nem sempre, no entanto, podemos contar com a presença de uma chave natural. Por exemplo, imagine um aplicativo de registro de "**anotações**", onde diversos usuários podem criar anotações ao mesmo tempo e, quando sincronizadas, todos eles recebem todas as anotações cadastradas. Se considerarmos que nenhum campo desta entidade é obrigatório nem, tampouco, existe um campo que garanta unicidade entre suas tuplas, teremos um sério problema.

Mais especificamente, vamos considerar que chave primária da entidade "anotação" no servidor pode é um inteiro sequencial. O problema é que no dispositivo móvel é possível criar anotações, que posteriormente são enviadas ao servidor e sincronizadas em outros dispositivos. Perceba que, no momento da criação desta anotação no dispositivo, seria preciso consultar o servidor para obter uma chave única. Mas isto impede que o sistema funcione quando não houver acesso à internet. É muito difícil garantir que a chave sequencial seja respeitada no dispositivo, uma vez que haverá outros dispositivos clientes criando tuplas na mesma entidade.

Para resolver este problema (finalmente chegando ao ponto), esta arquitetura propõe uma abordagem denominada "**desambiguação**". Por meio desta técnica o servidor centralizado disponibiliza um serviço (URI) que é acessado pelo aplicativo no momento em que este é instalado no dispositivo (exigindo a conexão à internet apenas neste momento). Este serviço concede uma chave única ao aplicativo, que é então armazenada localmente. Toda vez que o aplicativo está lidando com uma entidade que não possua uma chave primária natural, ele é utilizado como prefixo para formar a chave:

![](/docs/images/api/image_4.png)

No servidor a geração do prefixo de desambiguação é controlado por meio de um "*serial*" do banco de dados PostgreSQL. Assim, para que este serviço funcione corretamente, você precisa criar este *serial* no banco de dados da instância:

```sql
CREATE SEQUENCE titan._disambiguation INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1;
```

Desta forma, cada consulta ao serviço incrementa o *serial* garantindo que cada dispositivo receberá um prefixo único. No dispositivo este prefixo é armazenado localmente (usando a *Shared Preferences*), conforme veremos em um novo e-mail.

### POST ou PUT https://seu-host.com/instância/api/*gcm*

Este serviço permite registrar um dispositivo móvel para que receba mensagens na **Action Bar**. Para esta funcionalidade o [Google Cloud Message](https://developer.android.com/google/gcm/index.html) foi integrado ao [sistema de alertas do Titan](/docs/tutorials/alerts).

Esta funcionalidade funciona apenas caso esteja sendo utilizada a autenticação por meio dos métodos **CLIENT** ou **CLIENT-AS-USER**, uma vez que a chave GCM será armazenada na tabela '**_mobile**' para o dispositivo (previamente registrado) que está efetuando a requisição.

### GET https://seu-host.com/instância/api/*alerts*

### DELETE https://seu-host.com/instância/api/*alert/ + ID*

### PUT https://seu-host.com/instância/api/*alert/ + ID*

Estes métodos permitem que o usuário do dispositivo móvel interaja com o [sistema de alertas do Titan](/docs/tutorials/alerts). Perceba que é necessário que o usuário esteja autenticado (por meio dos métodos **CLIENT-AS-USER**, **USER**, **USER-BY-ID** e **USER-BY-MAIL**).

Respectivamente, o primeiro serviço permite obter todos os alertas do usuário:

```json
[
	{"id":12,"message":"Quisque eu ante nec libero consequat facilisis rutrum dapibus tortor.","icon":"SECURITY","read":"false"},
	{"id":11,"message":"Aliquam faucibus tortor et est sollicitudin ullamcorper.","icon":"CONFIRM","read":"false"}
]
```

O segundo método deleta um alerta do usuário, passando-se o ID do alerta. O terceiro marca um alerta como "lido".

Para não tornar muito grande este e-mail, vou encerrar a explicação por aqui. No próximo explicarei como é possível que você crie em suas seções seus próprios serviços (URIs).

## URIs de Seções

Nesta segunda parte sobre o uso da REST-Like API do Titan será explicado como habilitar URIs em suas seções de uma instância do *framework*.

Conforme explicado no e-mail anterior, a API do Titan aceita (até o momento) requisições utilizando os métodos **GET**, **PUT**, **POST** e **DELETE**. Sobre o uso destes métodos, considerem as seguintes observações:

1. O método **GET** permite "consumir" dados da instância, que virão sempre no formato JSON. Desta forma, os tipos de dados do Titan receberam um novo *adapter*, denominado "**toApi**", que é chamado por padrão quando do uso deste método e formata o dado para este tipo de saída;
2. Os métodos **POST** e **PUT** possuem diferenças conceituais dentro de uma arquitetura **RESTful**. Estas diferenças foram "reduzidas" no Titan, possibilitando que os métodos trabalhem quase da mesma forma, a critério do desenvolvedor. Este tipo de flexibilidade, que aparece em outros locais, é incompatível com as diretrizes RESTful e, por este motivo, chamamos de REST-Like; e
3. Em relação à entrada de dados nos serviços (*submit*), feita por meio do uso dos métodos **POST** e **PUT**, o Titan considera sempre que os dados enviados são parâmetros da requisição (e não, p.e., um JSON em seu corpo). Para tratar os dados de entrada, foi implementado o adapter "**fromApi**" nos tipos do Titan, que reconhece o formato de entrada e alimenta de forma apropriada o valor do dado no objeto instanciado.

Ao fazer uma requisição para a REST-Like API, esta passará primeiro por um *bootstrap* (no CORE, em '**api/api.php**'). Este avalia se a requisição é para um dos serviços globais (tratados na primeira parte desta documentação). Caso não seja, o Titan irá procurar uma seção homônima. Por exemplo:

### GET https://seu-host.com/instância/api/*embassy/active*

Repare que após a URL da instância vêm a palavra-chave "**api**". Por padrão, esta é a palavra-chave que define o "subdiretório" na *friendly* URL que diz que a requisição deve ser tratada pela REST-Like API. Você pode alterá-la (ou incluí-la, caso não exista), alterando o "**.htaccess**" da raiz da instância:

```bash
RewriteRule ^api\/([a-zA-Z0-9_\-\.\/\%]+)$ titan.php?target=api&uri=$1 [QSA,L]
```

O que vêm depois é o serviço requisitado. Neste exemplo trata-se da palavra "**embassy**". Como este termo não se refere a um dos serviços globais (**auth**, **alert**, **alerts**, **disambiguation**, **register** ou **gcm**), o Titan irá procurar uma seção denominada "**embassy**".

Para saber quem deve processar a requisição, o Titan procura no componente da seção, dentro da pasta "**\_api**" um script PHP homônimo ao terceiro "subdiretório", neste caso a palavra "**active**". Ou seja, supondo que o componente desta seção seja um "**global.generic**", para processar a requisição o Titan irá procurar pelo script "**[core]/repos/component/global.generic/\_api/_active.php_**".

Caso este terceiro nível não seja passado, por exemplo:

### POST https://seu-host.com/instância/api/*embassy*

Então o Titan procurará na pasta "**\_api**" um script homônimo ao método utilizado (neste caso "**[core]/repos/component/global.generic/\_api/_post.php_**").

A implementação dos serviços é muito semelhante ao das *engines* dos componentes (responsáveis pelas ações das seções). Entretanto, ao invés das tradicionais classes "**Form**" e "**View**", são utilizadas as classes "**ApiEntity**" e "**ApiList**" que funcionam de forma respectivamente semelhante.

O XML de definição do modelo de dados também é semelhante, mas a tag-raiz dele é a "**<api />**". Por exemplo:

{% highlight xml linenos %}
<?xml version="1.0" encoding="UTF-8"?>
<api table="cms.crud" primary="id" code="code">
	<field type="String" column="c_string" label="Tipo String" />
	<field type="Boolean" column="c_boolean" label="Tipo Boolean" />
	<field type="Date" column="c_date" label="Tipo Date" />
	<field type="File" column="c_file" label="Tipo File" />
	<field type="PlainText" column="c_text" label="Tipo Text" />
	<field type="Color" column="c_color" label="Tipo Color" />
	<field type="Cpf" column="c_cpf" label="Tipo CPF" />
	<field type="Cnpj" column="c_cnpj" label="Tipo CNPJ" />
	<field type="Enum" column="c_enum" label="Tipo Enumeration">
		<item value="_A_" label="Item A" />
		<item value="_B_" label="Item B" />
		<item value="_C_" label="Item C" />
		<item value="_D_" label="Item D" />
		<item value="_E_" label="Item E" />
		<item value="_F_" label="Item F" />
	</field>
	<field type="Fck" column="c_fck" label="Tipo FCK" />
	<field type="Cep" column="c_cep" label="Tipo CEP" />
	<field type="City" column="c_city" label="Tipo City" />
	<field type="State" column="c_state" label="Tipo State" />
	<field type="Select" column="c_select" label="Tipo Select" link-column="id" link-api="code" link-table="cms.select" link-view="title" />
	<field type="Float" column="c_float" label="Tipo Float" />
	<field type="Amount" column="c_integer" label="Tipo Integer" />
	<field type="Date" column="_update" show-time="true" id="_API_UPDATE_UNIX_TIMESTAMP_" on-api-as="last_change" />
</api>
{% endhighlight %}

O formato é o mesmo para instanciar tanto objetos de "**ApiEntity**" quanto de "**ApiList**".

Em destaque no XML acima, estão alterações no modelo de dados necessárias para a implementação de dois conceitos importantes da sincronização de dados da API.

O atributo "**code**" está relacionado ao uso de **desambiguação** nesta entidade da aplicação. Conforme explicado na primeira parte desta documentação, este conceito será utilizado quando precisamos garantir a sincronização de uma entidade (que não têm uma chave-primária natural) em diferentes dispositivos que podem criar novas tuplas desta entidade. Quando o atributo acima é colocado no modelo de dados, o Titan assume que, da API pra baixo, esta será a chave primária do objeto. Ou seja, o "**code**" funcionará como uma "**chave-primária virtual**". No aplicativo móvel e na API esta chave virtual é tratada como a chave primária do objeto, mas para o servidor é apenas uma chave única. Assim, o servidor passa a fazer a correlação entre a chave-primária real e a virtual. Internamente, continua seguindo um modelo ORM baseado em chaves-primárias serializadas.

Para que a tabela do modelo acima (a "**cms.crud**") 'aceite' trabalhar desta forma, é necessário inserir a coluna de "code" nela:

```sql
ALTER TABLE cms.crud ADD COLUMN code VARCHAR UNIQUE DEFAULT currval('cms.crud_id_seq'::regclass)::character varying NOT NULL;
```

Repare que o valor padrão da coluna "code" é o valor de "id" (a chave-primária real da entidade). Repare também que a coluna é do tipo "**character varying**" sem tamanho definido (tamanho dinâmico). Desta forma, sempre que um objeto for criado no servidor o valor de "**code**" será o mesmo de "**id**", entretanto, se ele for criado por um dispositivo, seu valor terá o formato de dois inteiros concatenados por um caracter (p.e., "**213.7659**", onde o "**213**" é o inteiro único provido para o dispositivo pelo serviço de desambiguação, e o "**7659**" é um inteiro sequencial no dispositivo).

Caso não seja utilizado o atributo "code" no modelo de dados, o Titan considerará a chave-primária real para sincronização. Quando não houver criação de objetos da entidade nos dispositivos você pode optar por esta solução mais simples.

O último "**field**", destacado em vermelho, será o campo que controlará a data da última atualização da tupla. Neste exemplo é utilizada a coluna mandatória "**\_update**". Recomenda-se utilizá-la sempre que estiver disponível. Esta coluna conterá a data de atualização do dado, indepente de onde foi alterado.

Você pode imaginar um fluxo de atualização de dados com uma instância do Titan ocorrendo da seguinte forma:

1. Primeiro, o dispositivo obtém a data da última sincronia de dados (um Unix *timestamp*). Este valor é 0 (zero) caso seja a primeira sincronização. No caso do desenvolvimento Android, este valor pode ter sido armazenado em uma variável do Shared Preferences.
2. Em seguida, varre-se a tabela da entidade que deseja-se sincronizar obtendo todas aquelas tuplas cuja a data de modificação for superior a da última sincronia.
3. Cada tupla obtida é enviada por PUT ou POST em um loop, ou seja, é realizada uma requisição para cada tupla.
4. O servidor recebe estas requisições e verifica se a tupla existe localmente (por meio da chave). Caso não exista, ela é criada no servidor. Caso exista e for mais recente, ela é atualizada.
5. Quando se encerra esse envio, o aplicativo requisita uma lista das chaves-primárias de todas as tuplas ativas.
6. Uma vez de posse desta lista, o aplicativo deleta localmente todas as tuplas que não estejam na lista.
7. O aplicativo requisita agora uma lista com todas as tuplas que tenham sofrido alteração desde a data da última sincronia (obtida no primeiro passo).
8. O aplicativo recebe um JSON com um vetor com todas as tuplas. Este vetor é varrido e são inseridas no DB todas as tuplas que não existam localmente. Aquelas que existem, é feita uma verificação e são atualizadas as mais recentes.
9. Por fim, o novo Unix *timestamp* é obtido da requisição e gravado localmente para a próxima sincronia.

É importante destacar que o relógio do servidor pode estar diferente do relógio do dispositivo. Por conta disso, a implementação do aplicativo móvel deve considerar que, na criação e edição de tuplas da entidade, a data de "last_change" deve sempre ser superior à data armazenada de última sincronia. Em um próximo e-mail, sobre os aplicativos gerados pelo Tita, falaremos mais desta solução.

Outro ponto que merece destaque está relacionado aos passos 4 e 5 do fluxo supracitado. Repare que a deleção de tuplas no dispositivo é feita com base em uma lista de chaves-primárias de tuplas ativas. Esta foi a técnica escolhida para remoção de tuplas, uma vez que não era desejável tornar muito complexo a arquitetura da entidade (p.e., adicionando uma tabela de histórico ou rastreio de deleções). Assim, em cada sincronia o aplicativo apaga todas as tuplas que não estejam na lista de objetos ativos do servidor.

Tudo o que foi exposto até aqui já está implementado no componente "**global.generic**". Assim, acessando a pasta "**\_api**" deste componente, você encontrará *scripts* para os seguintes serviços:

#### GET https://seu-host.com/instância/api/seção/*ID ou CODE*

Retorna o JSON do modelo de dados do item referenciado por ID ou CODE.

#### GET https://seu-host.com/instância/api/seção/list/*TIMESTAMP*

Retorna um vetor em JSON com o modelo de dados de todos os itens criados ou alterados após o TIMESTAMP passado.

#### GET https://seu-host.com/instância/api/seção/*active*

Retorna um vetor em JSON com a lista de todos os IDs ou CODEs dos itens ativos no servidor.

#### POST https://seu-host.com/instância/api/*seção*

Envia, por POST, um item para o servidor.

#### PUT https://seu-host.com/instância/api/seção/*ID ou CODE*

Envia, por PUT, um item para o servidor. Caso não exista, o item é criado.

#### DELETE https://seu-host.com/instância/api/seção/*ID ou CODE*

Apaga o item referenciado por ID ou CODE.

Assim, considere o [teste unitário e a instância-exemplo](https://github.com/titan-framework/sample-api) disponíveis. No teste unitário, além dos métodos de teste dos serviços globais, foram disponibilizados métodos para averiguar o funcionamento de todos os serviços acima em uma seção do "**global.generic**".
