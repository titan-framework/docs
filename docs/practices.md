---
layout: page
title: Boas Práticas
subtitle: Melhores práticas e convenções.
comments: true
---

Boas práticas de programação são um conjunto de regras informais que visam melhorar a qualidade das aplicações e simplificar a sua manutenção, reduzindo significativamente a probabilidade de erros em suas aplicações, além de facilitar o entendimento de novos códigos de forma rápida e completa.

Esta seção apresentará as convenções recomendadas para Titan Framework, que está sendo adequado às normas propostas no modelo de convenções do [PSR](http://www.php-fig.org/psr) (*PHP Standards Recommendation*). O objetivo de abordar este tema agora é garantir que as diretrizes elencadas sejam seguidas desde as primeiras instâncias desenvolvidas pelo leitor.

## Convenções para o Banco de Dados

- O nome de todas as entidades do banco de dados devem estar em **inglês**;
- O nome de todas as entidades do banco de dados devem estar no **singular**;
- O nome de todas as entidades do banco de dados devem estar em **caixa baixa** (*lower case*);
- Entidades "**mandatórias**", ou seja, cujo a existência, o nome ou o comportamento não possam ser parametrizados pelos arquivos de marcação da instância, devem ser **precedidas por ****_underscore_** (por exemplo, o componente nativo “**global.generic**” necessita que as tabelas que representam o modelo de dados de suas seções tenham as colunas “**_user**”, “_**create**” e “**_update**”); e
- Caso o nome da entidade seja composto de duas ou mais palavras, elas devem estar separadas por **_underscore_** (p.e., "my_table").

## Convenções de Código

- Os nomes de variáveis, funções, classes e demais entidades devem estar em **inglês**;
- Os nomes de variáveis locais, atributos e funções devem estar em **_Camel Case_** (a primeira palavra do nome é iniciada por letra minúscula, a próxima palavra é iniciada com maiúscula e todas são unidas sem qualquer caracter), tal como "$myFirstVar" ou “myFunction ()”;
- Caso seja um atributo de classe privado, o nome deve ser precedido com um *underscore* (p.e., "$_myPrivateAttribute");
- Os nomes das classes devem estar em **_Pascal Case_** (todas as palavras são iniciadas maiúsculas e são unidas sem espaço), tal como "MyClass";
- Os nomes das variáveis globais devem estar em caixa alta (*upper case*), tal como "$_MY_VAR";
- O nome das constantes devem estar em **caixa alta** (*upper case*), tal como  "MY_CONST";
- Utilize **Orientação a Objetos** e suas boas práticas;
- Busque manter funções pertinentes dentro das classes (mesmo que sejam métodos estáticos);
- Todas as *tags* e atributos em XML devem possuir apenas letras minúsculas (*lower case*);
- Sempre quebre a linha após ponto-e-vírgula, antes de um operador ou antes de abrir chaves (delimitador de escopo);
- Sempre utilize **tabulação** para a **identação** (jamais utilize o "espaço"). Se necessário, configure na IDE de desenvolvimento pois algumas, por padrão, utilizam o caracter de espaço;
- Sempre feche parênteses e chaves na mesma coluna ou na mesma linha em que foram abertos;
- Busque utilizar linhas em branco entre funções e métodos, entre classes e entre expressões com variáveis distintas;
- Em todos os arquivos deve-se utilizar o padrão de cabeçalhos e comentários especificado pelo [PHPDoc](http://www.phpdoc.org/);
- Sempre que aplicável, utilize *Design Patterns*; e
- Jamais utilize *deprecated features*.
