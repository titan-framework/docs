---
layout: page
title: Log e Auditoria
subtitle: Sistema de log para auditoria.
comments: true
---

O Sistema de Log do Titan visa registrar todas as ações de todos os usuários no sistema, possibilitando a posterior auditoria pelos administradores.

Para ativá-lo, verifique se a tag '**log**' está ativa no '**configure/titan.xml**':

```xml
<titan-configuration>
	...
	<log
		db-path="cache/log.db"
		xml-path="configure/log.xml"
	/>
	...
</titan-configuration>
```

O atributo '**db-path**' contém o caminho para banco de dados [SQLite](http://sqlite.org) onde será armazanado o log. Este arquivo será criado automaticamente e, portanto, deve estar em um diretório na qual sua instância possa escrever. Por convenção o arquivo é criado normalmente na pasta de cache ("**cache/log.db**").

Com os passos executados até aqui o sistema já irá gravar as atividades de todas as seções instanciadas com componentes nativos.

O componente nativo "**global.group**" possui uma _engine_ para visualização amigável das atividades. Desenvolvedores experientes podem utilizar esta _engine_ como base para criar outros visualizadores de LOG da forma que achar mais apropriado. Caso a ação para esta _engine_ não esteja ativa, na sua seção apropriada (instanciada do componente "**global.group**"), faça:

1. Crie um arquivo na pasta da seção denominado "**log.xml**" com o seguinte conteúdo:

```xml
<?xml version="1.0" encoding="ISO-8859-1"?>
<search table="log">
	<field type="Phrase" column="user_name" label="Autor" />
	<field type="Phrase" column="section_name" label="Seção" />
	<field type="Phrase" column="action_name" label="Ação" />
	<field type="Phrase" column="message" label="Conteúdo" />
	<field type="Phrase" column="ip" label="IP" />
</search>
<view table="log" primary="id" paginate="50">
	<field type="Phrase" column="user_name" label="Usuário" />
	<field type="Date" column="date" label="Data" show-time="true" id="_DATE_" />
	<order id="_DATE_" invert="true" />
	<icon function="[ajax]" action="logView" image="view.gif" label="Visualizar Log" />
</view>
```

2. No arquivo "**config.inc.xml**" adicione a seguinte ação:

```xml
</action-mapping>
	...
	<action
		name="log"
		label="Sistema de Log de Atividades">
		<menu function="search" />
		<menu action="list" />
	</action>

	<action
		name="logView"
		label="Visualizar Log de Atividades">
	</action>
	...
</action-mapping>
```

3. De permissão aos grupos de usuários que poderão visualizar os LOGs de atividades.

Ao final destes passos o sistema estará registrando as atividades realizadas nas seções instanciadas a partir de componentes nativos e estas atividades serão listadas e poderão ser visualizadas na sua seção instanciada a partir do componente "**global.group**".

Para adicionar o registro de LOG ao seu componente basta utilizar a função:

```php
Log::singleton ()->add ()
```

Esta função registra o LOG de várias formas e os exibe em diversos níveis de detalhes. A forma mais básica de utilizá-la em seu componente é, simplesmente:

```php
Log::singleton ()->add ('Minha mensagem bonitinha de log. lalalala');
```

O LOG será registrado e exibido conforme determinado na tag GENERIC do arquivo "**configure/log.xml**". Para modificar a forma como o LOG é exibido basta modificar este arquivo. A tag GENERIC configura como todas as mensagens sem uma tag específica são exibidas.

Para criar suas próprias tags e, assim, possibilitar a visualização diferenciada do conteúdo de uma atividade basta adicionar uma nova tag ao arquivo "**configure/log.xml**". Por exemplo:

```xml
<activity name="TAG_DO_JOAO" label="Solicitação Enviada" message="O usuário [_USER_NAME_] fez uma solicitação.">

[_MESSAGE_]

Data: [_DATE_]
Seção: [_SECTION_] ([_COMPONENT_])
Ação: [_ACTION_] ([_ENGINE_])
Autor: [_USER_NAME_]
Login: [_USER_LOGIN_]
E-mail: [_USER_MAIL_]
Tipo: [_USER_TYPE_]
ID do Usuário: [_USER_ID_]
IP: [_IP_]
Processado em [_BENCHMARK_] segundos
</activity>
```

E na chamada da função de LOG ficaria assim:

```php
Log::singleton ()->add ('TAG_DO_JOAO', 'Solicitação de reembolso de dinheiro pois o produto estava estragado.');
```

As palavras-chave disponíveis para a configuração de tag são:

- **[_MESSAGE_]**: Mensagem;
- **[_IP_]**: IP do usuário;
- **[_USER_NAME_]**: Nome do usuário;
- **[_USER_LOGIN_]**: Login do usuário;
- **[_USER_MAIL_]**: E-mail do usuário;
- **[_USER_TYPE_]**: Tipo do usuário;
- **[_USER_ID_]**: ID do usuário;
- **[_SECTION_]**: Label da seção (p.e. Notícias);
- **[_COMPONENT_]**: Componente (p.e. global.generic);
- **[_ACTION_]**: Label da ação (p.e. Editar Item);
- **[_ACTION_NAME_]**: Nome da ação (p.e. edit_step_1);
- **[_ENGINE_]**: Engine da ação (p.e. edit);
- **[_BROWSER_]**: Navegador Web utilizado pelo usuário; e
- **[_DATE_]**: Data e hora do log.

Os parâmetros da função **add ()** são:

```php
public function add ($activity, $message = FALSE, $priority = Log::INFO, $logged = TRUE, $authoring = TRUE)
```

Se você precisa gravar a prioridade do LOG, passe para o parâmetro $priority os seguintes valores:

```php
Log::EMERGENCY
Log::ALERT
Log::CRITICAL
Log::ERROR
Log::SECURITY
Log::WARNING
Log::NOTICE
Log::INFO
Log::DEBUG
```

Se você estiver utilizando a função em uma área de acesso não autenticado, como um _script_ público, passe **FALSE** no parâmetro '_$authoring_'.
