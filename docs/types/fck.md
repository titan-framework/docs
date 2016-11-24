---
layout: page
title: Fck
subtitle: Representação de textos ricos (multimídia).
comments: true
---

![Campo de entrada de dados do tipo "Fck".](/docs/types/fck/image_0.png)

Utilizado para possibilitar a entrada e representação de texto com formatação HTML. Oferece ao usuário um editor de textos que possibilita formatar o conteúdo de forma amigável (ou seja, um editor [WYSIWYG](http://pt.wikipedia.org/wiki/WYSIWYG)). Uma representação da entrada deste tipo de dado pode ser visualizada na figura acima. É representado no banco de dados pelo tipo '*text*':

{% highlight sql linenos %}
ALTER TABLE tabela ADD COLUMN coluna TEXT;
{% endhighlight %}

Um exemplo de instanciação do campo é o seguinte:

{% highlight xml linenos %}
<field
	type="Fck"
	column="description"
	label="Description | pt_BR: Descrição | es_ES: Descripción"
	owner-only="true"
	public="false"
	embedded-images="true"
/>
{% endhighlight %}

Os atributos "**owner-only**" e "**public**" funcionam da mesma forma que os atributos homônimos do tipo [File](/docs/types/file). Assim, caso o valor de "**public**" seja "*false*", quando um arquivo é enviado ao servidor, o tipo "Fck" atribui a ele uma chave (*hash*) que funciona como senha. O arquivo somente é exibido caso esta chave seja passada. Quando o arquivo é inserido no texto rico, o link gerado já possui a chave. Isto significa que, caso este texto seja utilizado em uma área pública (p.e., uma *homepage*), os arquivos serão exibidos corretamente. Caso, entretanto, este texto seja utilizado de forma privada, seu arquivos estarão seguros do acesso alheio.

O tipo "Fck" possui um aprimorado suporte à arquivos multimídia, possibilitando, além de **imagens**, o envio de **vídeos** e **aúdios** que são exibidos pelo *player* padrão do HTML5. Para que esta exibição seja possível, alguns tipos de arquivos de aúdio e vídeo precisam ser convertidos para os tipos suportados pelo HTML5. Assim, é necessário que o servidor que hospeda a instância do Titan tenha o utilitário "**avconv**" instalado.

![Funcionalidades para inclusão de arquivos multimídia.](/docs/types/fck/image_1.png)

Para instalar o "avconv" no Windows, baixe a biblioteca "libav" no link abaixo, descompacte-a em seu sistema de arquivos e insira o caminho absoluto até a pasta "usr\bin" da biblioteca no path de seu Windows.

[http://builds.libav.org/windows/](http://builds.libav.org/windows/)

Para instalar no Debian, faça:

{% highlight bash linenos %}
su -
aptitude update
aptitude install libav-tools
{% endhighlight %}

Em relação ao atributo "**embedded-images**". O objetivo é ser utilizado com a [API REST-Like](/docs/api) do Titan visando facilitar a disponibilização *offline* das imagens de textos ricos em aplicativos móveis. Este atributo é por padrão "*false*". Quando ativado (em um XML de mapeamento de entidade para o barramento de serviços) ele fará com que o Titan troque todas as URLs das imagens do valor do campo do tipo Fck por um imagem embutida (em base64) na própria tag 'img'. Com isso o conteúdo pode ser gravado no banco de dados local do aplicatio e, ao ser aberto em um WebView, irá exibir as imagens sem necessidade de baixá-las da internet.
