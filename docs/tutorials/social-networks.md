---
layout: page
title: Redes Sociais
subtitle: Integração da instância com redes sociais.
comments: true
---

Disponibilizei uma versão estável do Titan com uma nova API para **integração de instâncias com redes sociais**. A versão inicial integra apenas o Facebook e permite, por enquanto, apenas o registro e login automático na instância. É uma versão ALPHA e seu uso em produção é fortemente desencorajado. Estou divulgando para os aventureiros me ajudarem em testes e enviarem contribuições.

![](/docs/tutorials/alerts/image_0.png)

Ao clicar no botão da rede social o usuário deve conceder permissão à aplicação para acessar os dados de seu perfil. Com acesso a estes dados o Titan verifica se há algum cadastro na base da instância vinculado àquele perfil. Não havendo, o Titan verifica se há algum cadastro com o mesmo e-mail do perfil. Por conta desta regra, a integração com redes sociais **funciona apenas se a coluna '\_email' da tabela '\_user' for _UNIQUE_**. O Titan também faz essa verificação no LDAP, caso o sistema esteja utilizando. Se existir um cadastro com o mesmo e-mail, o perfil na rede social é vinculado à ele. Caso não exista, é criado um novo cadastro (*on-the-fly*). Neste ponto existe uma limitação da versão atual da API: não é possível, ainda, editar dados adicionais antes do registro do usuário na instância. Ou seja, isso significa que se, por exemplo, for obrigatório ao cadastro do usuário o preenchimento do CPF, não há um passo em que ele pode adicionar esta informação. Por enquanto você terá que cuidar disto em um componente dentro da instância. Este problema se propaga também no uso de LDAP. A API cria o usuário (caso ele não exista) no servidor LDAP, mas insere apenas campos básicos que normalmente existem em qualquer servidor OpenLDAP.

Repare que, uma vez inserido na instância, o usuário sempre poderá se autenticar pela rede social. O sistema gera automaticamente um login (baseado no login da rede social) e uma senha (randômica). Caso o usuário queira logar utilizando também esta senha, terá que alterá-la pelo "Esqueci minha senha".

A API utiliza uma arquitetura baseada em DRIVERs, semelhante aos componentes que estamos acostumados. Assim, é possível criar novos drivers não-nativos ou sobrecarregar os nativos para que se comportem de forma diferente.

Os drivers estão localizados dentro do repositório ("[CORE]/repos/social/"). Para ativar o uso da API, basta colocar no 'configure/titan.xml' a referência para o arquivo de mapeamento:

```xml
<social
	xml-path="configure/social.xml"
/>
```

Neste caso o arquivo se chama 'social.xml' e está dentro da pasta 'configure/'. Seu conteúdo é semelhante ao seguinte:

{% highlight xml linenos %}
<?xml version="1.0" encoding="UTF-8"?>
<social-mapping>
	<social
		driver="Facebook"
		register-as="community"
		auth-id="XXXXXXXXXX"
		auth-secret="YYYYYYYYYY">
		<attribute name="username" column="_login" />
		<attribute name="name" column="_name" />
		<attribute name="email" column="_email" permission="email" />
		<attribute name="timezone" column="_timezone" />
		<attribute name="locale" column="_language" />
		<attribute name="birthday" column="birth_date" permission="user_birthday" />
		<attribute name="gender" column="gender" />
		<attribute name="picture" column="photo" />
		<attribute name="website" column="url" permission="user_website" />
		<attribute name="relationship_status" column="marriage" permission="user_relationships" />
		<attribute name="link" column="facebook" />
		<!--
		<attribute name="hometown" column="" permission="user_hometown" />
		<attribute name="bio" column="" permission="user_about_me" />
		-->
	</social>
</social-mapping>
{% endhighlight %}

Apenas o driver nativo para Facebook está disponível por enquanto. Para habilitar, é necessário primeiro registrar sua aplicação no **Facebook Developers**. Para isto, acesse o site do [Facebook Developers](https://developers.facebook.com) e se registre como desenvolvedor. Em seguida, no menu superior, vá em "**Apps**" e, depois, no botão "**Create New App**".

![](/docs/tutorials/alerts/image_1.png)

Pronto, copie a "**App ID**" e a "**App Secret**" para os campos "**auth-id**" e "**auth-secret**" da configuração do driver no '**configure/social.xml**'. No atributo '**register-as**' deve ser inserido o nome do tipo de usuário (configurado no arquivo '**configure/security.xml**') que será atribuído ao cadastro do usuário quando ele for criado na instância. Por fim, são mapeados os [campos que vêm do Facebook](https://developers.facebook.com/docs/reference/api/user/) com as colunas que existem na tabela '**_user**' da instância.

Os valores do Facebook precisam ser transformados antes de serem salvos na instância. Para fazer esta transformação os drivers do Titan trabalhando com "*adapters*". Os *adapters* nativos estão localizados na pasta '**\_adapter**' do driver. Caso tenha uma coluna na sua tabela '\_user' que possua um formato diferente, você precisará sobreescrever este *adapter*. Por exemplo, o atributo "**gender**" vêm com os seguintes valores do Facebook: '**female**' ou '**male**'. Por padrão, a coluna '**gender**' sugerida na instância-base do Titan aceita os valores '**\_F\_**' e '**\_M\_**'. Sua instância, no entanto, pode não adotar este padrão. Assim, você terá que sobreescrever o *adapter* nativo. Para isto basta criar uma pasta local (p.e., '**local/social/Facebook/\_adapter/**') e copiar para ela o "**gender.php**" nativo (pasta '\_adpater' do driver no repositório do CORE). Altere o código e, na declaração do atributo na configuração do driver no arquivo '**configure/social.xml**' adicione o '**adapter**':

{% highlight xml linenos %}
<?xml version="1.0" encoding="UTF-8"?>
<social-mapping>
	<social
		driver="Facebook"
		register-as="community"
		auth-id="XXXXXXXXXX"
		auth-secret="YYYYYYYYYY">
		<attribute name="username" column="_login" />
		<attribute name="name" column="_name" />
		<attribute name="email" column="_email" permission="email" />
		<attribute name="timezone" column="_timezone" />
		<attribute name="locale" column="_language" />
		<attribute name="birthday" column="birth_date" permission="user_birthday" />
		**<attribute name="gender" column="gender" ****adapter="local/social/Facebook/_adapter/gender.php"**** />**
		<attribute name="picture" column="photo" />
		<attribute name="website" column="url" permission="user_website" />
		<attribute name="relationship_status" column="marriage" permission="user_relationships" />
		<attribute name="link" column="facebook" />
		<!--
		<attribute name="hometown" column="" permission="user_hometown" />
		<attribute name="bio" column="" permission="user_about_me" />
		-->
	</social>
</social-mapping>
{% endhighlight %}

Você pode facilmente importar outras informações para a instância adicionando novas tags "**attribute**". Perceba que algumas informações requerem permissões especiais. Estas devem ser passadas por meio da palavra-chave '**permission**'.

Além dos XMLs, é necessário inserir no DB a coluna onde ficará armazenada o ID do usuário na rede social (desta forma, mesmo que ele venha a alterar seu e-mail posteriormente, o perfil continuará relacionado ao cadastro):

```sql
ALTER TABLE titan._user ADD COLUMN _facebook BIGINT;
ALTER TABLE titan._user ADD CONSTRAINT _user__facebook_key UNIQUE (_facebook);
```

Lembrando que a coluna '\_email' precisa ser *UNIQUE*:

```sql
ALTER TABLE titan._user ADD CONSTRAINT _user__email_key UNIQUE (_email);**
```

A tag '**social**' aceita que seja passado um '**path**' para o caso de você querer sobreescrever um driver completamente ou criar um driver para uma rede não contemplada pelos drivers nativos. Para criar drivers basta estender a classe abstrata "**SocialDriver**" e implementar os métodos requeridos.
