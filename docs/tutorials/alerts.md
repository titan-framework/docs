---
layout: page
title: Alertas
subtitle: Ativação do sistema de notificações.
comments: true
---

Foi implementado no Titan um Sistema de Alertas inspirado nas notificações do Android. Trata-se de uma API simples que possibilita avisar usuários específicos de ações executadas no sistema relacionadas a eles. Para que funcione de maneira adequada o ideal é que esteja habilitado o job 'daily' para rodar diariamente (ver e-mail com subject "Scheduler Jobs").

O sistema de alertas envia notificações aos usuários de duas formas: por e-mail e por meio da interface da instância. A figura abaixo mostra como fica a interface com os alertas ativos.

![](/docs/tutorials/alerts/image_0.png)

Para habilitar o Sistema de Alertas, o primeiro passo é incluir algumas entidades mandatórias ao *schema* padrão do Titan no DB. Caso esteja criando uma instância nova utilizando o [Composer](https://getcomposer.org), estas entidades já estarão criadas e você pode pular este passo.

{% highlight sql linenos %}
CREATE TABLE _alert (
  _id SERIAL,
  _template VARCHAR(64) NOT NULL,
  _assign VARCHAR(64) NOT NULL,
  _until TIMESTAMP WITHOUT TIME ZONE,
  _parameters TEXT,
  _user INTEGER,
  _create TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  _update TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  CONSTRAINT _alert_idx UNIQUE(_template, _assign),
  CONSTRAINT _alert_pkey PRIMARY KEY(_id),
  CONSTRAINT _alert_user_fk FOREIGN KEY (_user)
	REFERENCES _user(_id)
	ON DELETE CASCADE
	ON UPDATE CASCADE
	NOT DEFERRABLE
);

CREATE TABLE _alert_user (
  _alert INTEGER NOT NULL,
  _user INTEGER NOT NULL,
  _read BIT(1) DEFAULT B'0'::"bit" NOT NULL,
  _delete BIT(1) DEFAULT B'0'::"bit" NOT NULL,
  CONSTRAINT _alert_user_idx PRIMARY KEY(_alert, _user),
  CONSTRAINT _alert_user_fk FOREIGN KEY (_alert)
	REFERENCES _alert(_id)
	ON DELETE CASCADE
	ON UPDATE CASCADE
	NOT DEFERRABLE,
  CONSTRAINT _alert_user_user_fk FOREIGN KEY (_user)
	REFERENCES _user(_id)
	ON DELETE CASCADE
	ON UPDATE CASCADE
	NOT DEFERRABLE
);

CREATE TABLE _alert_mail (
  _alert INTEGER NOT NULL,
  _trigger TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  _send BIT(1) DEFAULT B'0'::"bit" NOT NULL,
  CONSTRAINT _alert_mail_idx PRIMARY KEY(_alert, _trigger),
  CONSTRAINT _alert_mail_fk FOREIGN KEY (_alert)
	REFERENCES _alert(_id)
	ON DELETE CASCADE
	ON UPDATE CASCADE
	NOT DEFERRABLE
);
{% endhighlight %}

O passo posterior é inserir no 'configure/titan.xml' uma tag 'alert':

```xml
<alert
	xml-path="configure/alert.xml"
/>
```

E criar na pasta 'configure/' da instância um novo arquivo XML denominado 'alert.xml'. Este arquivo deverá possuir a seguinte sintaxe:

{% highlight xml linenos %}
<?xml version="1.0" encoding="ISO-8859-1"?>
<alert-mapping>
	<alert
		id="_OPORTUNITY_KNOWLEDGE_"
		message="Há uma nova oportunidade de estágio do(a) supervisor(a) [SUPERVISOR] na sua área de conhecimento ([KNOWLEDGE])"
		go="titan.php?target=body&toSection=trainee.oportunity.choose&toAction=list"
		icon="titan.php?target=loadFile&file=interface/alert/info.gif"
		subject="[Pandora] Disponibilizada uma oportunidade de estágio na sua área">
Olá [USER],
O supervisor [SUPERVISOR] disponibilizou uma oportunidade de estágio na sua área de conhecimento: [KNOWLEDGE].
Para ver mais informações desta oportunidade bem como outras propostas de estágio na Embrapa, acesse o Módulo de Estágios do Pandora clicando no link abaixo (ou copie e cole no seu navegador):
[URL]titan.php?toSection=trainee.oportunity.choose&toAction=list
Sem mais,
Equipe Pandora
	</alert>
	...
</alert-mapping>
{% endhighlight %}

Pode-se ter diversas tags "alert", desde cada uma tenha um 'id' único. O atributo 'message' será a notificação que irá aparecer na interface da instância, o 'go' é para onde o usuário será redirecionado ao clicar na mensagem e o 'icon' é o ícone que aparece ao lado esquerdo da mensagem. O atributo 'subject' e o conteúdo da tag referem-se ao assunto e ao corpo do e-mail, respectivamente, que será enviado ao usuário.

Os atributos 'message', 'go', 'subject' e o conteúdo da tag podem utilizar hashtags para customizar as informações. Pode-se utilizar hashtags padrões e enviar novas hashtags no momento do registo do alerta. As hashtags padrões são:

- **[SYSTEM]** - Nome da instância;
- **[URL]** - URL da instância;
- **[AUTHOR]** - O nome do usuário que acionou a ação que gerou o alerta;
- **[USER]** - O nome do usuário que está sendo alertado;
- **[DAYS_MISSING]** - Caso haja um limite para o alerta ser atendido, esta hash apresenta quantos dias faltam para o limite ser atingido. Ela é dinâmica, ou seja, utilizá-la em uma mensagem fará com que a os dias faltantes apresentados na mensagem sejam atualizados a medida em que a data se aproxima;
- **[UNTIL]** - Data limite para o alerta ser atendido; e
- **[DATE]** - Data de geração do alerta.

Agora, basta registrar o alerta em qualquer componente local da instância. Para isto, é disponibilizado o seguinte método estático:

```php
Alert::add ($template, $assign, $users, $tags = NULL, $until = NULL, $author = NULL, $overwrite = TRUE, $mail = NULL);
```

Onde:

- **$template** - É o ID da tag 'alert' do XML 'configure/alert.xml' que será utilizado no alerta;
- **$assign** - É uma assinatura única para o alerta que identifique a entidade a qual está vinculado;
- **$users** - Uma array com os usuários que receberão o alerta;
- **$tags** - Uma array com novas hashtags e seus valores correspondentes (também pode-se passar uma hashtag homônima a alguma do sistema para sobreescrevê-la);
- **$until** - A data limite para o alerta ser atendido. Caso não seja preenchido o alerta ficará visível ao usuário até que este o apague;
- **$author** - Força o autor do alerta passando um novo ID de usuário. Caso seja passado NULL o sistema coloca, por padrão, o ID do usuário logado;
- **$overwrite** - Caso esta opção seja TRUE (padrão), um alerta poderá ser sobreescrito (mesmo ID de template e assinatura) fazendo com que ele volte a ficar "não-lido" para os usuários e sobreescrevendo as demais informações; e
- **$mail** - O sistema envia um e-mail no momento em que o alerta é registrado, entretanto, pode-se passar neste parâmetro um vetor com um ou mais Unix timestamp para que o sistema envie novos e-mails no caso do alerta ainda não ter sido atendido. Esta funcionalidade funcionará apenas se o scheduler job 'daily' estiver ativo.

Um exemplo de uso do método é mostrado a seguir. Nele, ao ser registrado uma nova proposta de estágio envio um alerta a todos usuários da mesma área de conhecimento:

{% highlight xml linenos %}
$sql = "SELECT _id FROM _user WHERE _deleted = B'0' AND _active = B'1' AND knowledge IS NOT NULL AND knowledge IN (WITH RECURSIVE __all_know AS (SELECT id FROM metadata.knowledge WHERE father = '". $form->getField ('_KNOWLEDGE_')->getValue () ."' OR id = '". $form->getField ('_KNOWLEDGE_')->getValue () ."' UNION ALL SELECT b.id FROM __all_know a, metadata.knowledge b WHERE a.id = b.father) SELECT id FROM __all_know)";

$sth = Database::singleton ()->prepare ($sql);
$sth->execute ();
$users = array ();
while ($users [] = $sth->fetchColumn ());
Alert::add ('_OPORTUNITY_KNOWLEDGE_', $itemId, $users,
			array ('[KNOWLEDGE]' => Form::toText ($form->getField ('_KNOWLEDGE_')),
				   '[SUPERVISOR]' => Form::toText ($form->getField ('_SUPERVISOR_')),
				   '[ID]' => $itemId),
			NULL, $form->getField ('_SUPERVISOR_')->getValue (), FALSE);
{% endhighlight %}

Explicando com mais detalhes a figura já mostrada:

![](/docs/tutorials/alerts/image_1.png)

Pode ser interessante remover totalmente um alerta caso o usuário execute uma determinada ação que tire o sentido do alerta. No meu exemplo o usuário poderia se cadastrar na oportunidade ofertada. Para possibilitar isto foi criado o seguinte método estático:

```php
Alert::remove ($template, $assign);
```

Também foi implementado um garbage collector que remove alertas cujo a data 'until' já tenha sido alcançada ou que todos os usuários envolvidos já tenham apagado a notificação de interface e todos os e-mails tenham sido enviados. Novamente, para que esta importante ferramenta de otimização funcione corretamente é necessário que o job 'daily' esteja ativo.
