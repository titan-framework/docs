---
layout: page
title: Tipos Nativos
subtitle: Tipos nativos que instanciam campos de formulários.
comments: true
---

Os tipos do Titan são organizados em uma relação de pai e filho (classe derivada). Assim, o tipo "**global.Amount**" é derivado do tipo “**global.Integer**”, ou seja, o primeiro utiliza o segundo como base, mas implementa comportamentos específicos. Por exemplo, no caso do "global.Amount" o campo que aparecerá no formulário, bem como o número mostrado em uma ação de visualização, serão formatados por meio de uma máscara que separa os 'milhares' por ponto.

Esta característica permite que um desenvolvedor estenda facilmente os tipos nativos. Por exemplo, ao criar um novo tipo denominado "ProjectName.MyType" que herda o tipo nativo “global.Radio”, este novo tipo terá todas as funcionalidades do tipo nativo. Se observarmos, entretanto, o tipo nativo “global.Radio”, veremos que ele herda o tipo “global.Enum”. Este último, por sua vez, herda o tipo “global.Phrase”. Assim, podemos concluir que o tipo “ProjectName.MyType” têm características de todos estes tipos, que foram sobreescritas hierarquicamente na relação hereditária. Na figura abaixo é mostrada esta relação hereditária entre os tipos nativos do Titan.

![Relação hereditária entre os tipos nativos do Titan.](/docs/images/image_5.png)

Repare que no Titan para fazer até mesmo pequenas distinções comportamentais como a do tipo "global.Amount" em relação ao “global.Integer”, que fogem das configurações nativas disponíveis nos atributos de parametrização no XML, é necessário estender os tipos existentes.

Todos os tipos do Titan são mapeados em arquivos de marcação XML com o uso da tag "**field**". Todos eles compartilham alguns atributos básicos, mas podem também ter atributos específicos. Por exemplo, o tipo “Double” possui um atributo denominado “*precision*”, onde o desenvolvedor pode estipular qual o número de casas decimais do campo. Os atributos padrões, comuns a todos os tipos, são:

- **type**: nome do tipo;
- **column**: nome da coluna na tabela no banco de dados;
- **label**: rótulo do campo;
- **help**: informação adicional sobre o campo, acessível ao usuário por um ícone de ajuda ao lado direito do campo;
- **tip**: dica de preenchimento do campo, que aparece em um fundo azul imediatamente após a área de preenchimento do campo;
- **table**: tabela no banco de dados a que se refere o campo (por padrão utiliza a declarada no formulário);
- **value**: valor padrão a ser atribuído ao campo;
- **id**: um identificador único, que permite obter o objeto instanciado deste campo no código da aplicação (por padrão o Titan preenche este atributo com um valor único);
- **required**: aceita 'true' ou 'false' para determinar se o preenchimento do campo é obrigatório ou não (por padrão é 'false');
- **unique**: aceita 'true' ou 'false' para determinar se o valor deve ser único ou não (por padrão é 'false');
- **read-only**: aceita 'true' ou 'false' configurando para que o campo não seja editável em determinado formulário (por padrão é 'false');
- **restrict**: utilizado em conjunto com o sistema de controle de acesso do framework, determinando se o campo poderá ser editado apenas por usuários com permissões específicas;
- **style**: permite alterar a aparência do campo utilizando CSS; e
- **doc**: informações adicionais sobre o campo para serem inseridas no manual automaticamente gerado pelo *framework*.

Desta forma, poderíamos, por exemplo, instanciar um formulário com um único campo do tipo "Phrase" utilizando os atributos padrões listados acima:

{% highlight xml linenos %}
<form table="nome_da_tabela" primary="chave_primaria">
	<field
		type="Phrase"
		column="nome_da_coluna"
		id="_ID_UNICO_PARA_ESTE_CAMPO_"
		label="My Test Field | pt_BR: Meu Campo Teste | es_ES: Meu Campo Teste"
		value="O valor padrão deste campo é esta frase."
		required="true"
		unique="false"
		read-only="false"
		style="border-color: #900; font-weight: bold; color: #090;"
		tip="Ex.: Uma frase qualquer."
		help="Preencha uma frase a seu gosto."
		doc="Exemplo do uso dos tipos do Titan na criação de campos de formulários."
	/>
</form>
{% endhighlight %}

Que resultará na renderização mostrada na figura abaixo.

![Renderização de um *field* em um formulário.](/docs/images/image_6.png)

Os tipos nativos disponíveis são: [Phrase](/docs/types/phrase), [PlainText](/docs/types/plain-text), [Fck](/docs/types/fck), [Cpf](/docs/types/cpf), [Cnpj](/docs/types/cnpj), [Cep](/docs/types/cep), [Email](/docs/types/email), [Phone](/docs/types/phone), [Login](/docs/types/login), [Url](/docs/types/url), [Enum](/docs/types/enum), [Radio](/docs/types/radio), [CheckBox](/docs/types/check-box), [Twitter](/docs/types/twitter), [Color](/docs/types/color), [Slug](/docs/types/slug), [TimeZone](/docs/types/time-zone), [Integer](/docs/types/integer), [Amount](/docs/types/amount), [Boolean](/docs/types/boolean), [File](/docs/types/file), [Double](/docs/types/double), [Money](/docs/types/money), [Select](/docs/types/select), [Cascade](/docs/types/cascade), [City](/docs/types/city), [State](/docs/types/state), [Multiply](/docs/types/multiply), [Collection](/docs/types/collection), [Document](/docs/types/document), [Date](/docs/types/date) e [Time](/docs/types/time).
