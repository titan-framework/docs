---
layout: page
title:  Login
subtitle: Representação de campo de login.
comments: true
---

Utilizado para possibilitar a entrada e representação de logins quando a instância é integrada à serviços de diretórios (tal como o Active Directory ou o LDAP). Permite apenas o uso de dígitos (0-9), letras minúsculas (a-z), *underscore* (_) e ponto (.). É representado no banco de dados pelo tipo '*character varying*':

{% highlight sql linenos %}
ALTER TABLE tabela ADD COLUMN coluna VARCHAR(64) NOT NULL UNIQUE;
{% endhighlight %}

Este tipo é destinado ao uso, principalmente, em formulários de edição de dados de usuários, ou seja, tuplas da tabela mandatória '**_user**':

{% highlight xml linenos %}
<form table="titan._user" primary="_id">
	...
	<field
		type="Login"
		column="_login"
		label="Login"
		max-length="64"
		required="true"
		unique="true"
		help="Login utilizado para acessar o sistema."
	/>
	...
</form>
{% endhighlight %}
