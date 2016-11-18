---
layout: page
title:  TimeZone
subtitle: Representação de fuso horário.
comments: true
---

Este é um tipo criado especialmente para aprimorar o suporte do Titan ao fuso horário do usuário. Para que as instâncias do Titan consigam mostrar a hora correta aos usuários que o utilizam, elas precisam corrigir a hora atual, obtida do servidor, com o fuso do usuário. Para obter o fuso correto, as instâncias utilizam três procedimentos.

O de maior é precedência é a escolha do usuário. Para permitir que o usuário selecione seu fuso horário basta inserir no formulário de atualização de perfil (geralmente o 'modify.xml' da seção) um campo que mapeie este tipo:

{% highlight xml linenos %}
<field type="TimeZone" label="Time Zone | pt_BR: Fuso Horário | es_ES: Huso Horario" />
{% endhighlight %}

O campo gerado será um menu *drop-down* como todos os fuso horários mundiais. Repare que não é necessário inserir o nome da coluna, que por padrão será o nome da coluna mandatória '**_timezone**' da tabela '**_user**'. Pode-se, no entanto, utilizar este campo para outros fins, que não no perfil do usuário. Neste caso pode-se alterar o atributo '**column**' de forma apropriada.

É importante salientar que, caso o usuário não tenha escolhido um fuso horário, ou seja, o valor da coluna '**_timezone**' na tabela '**_user**' seja nulo, vazio ou caso ela não exista, o Titan tentará obter o *time zone* a partir do navegador. Caso também não consiga, por qualquer motivo, o Titan utiliza então o *time zone* definido no atributo '**timezone**' da tag '**<titan-configuration />**' do arquivo '**configure/titan.xml**' da instância.
