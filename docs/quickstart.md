---
layout: page
title: Quickstart
subtitle: Instanciando em 3 minutos sua aplicação.
---

Para instanciar sua primeira aplicação, utilize o [Composer](http://getcomposer.org):

```bash
php composer.phar create-project titan-framework/instance path/to/local/folder
```

Após finalizar o comando acima, inicialize a *box* do [Vagrant](http://vagrantup.com) para executar sua aplicação:

```bash
cd path/to/local/folder
vagrant up
```

Ao término, sua instância estará rodando em **http://localhost:8090**. Para acessá-la, utilize "**admin**" nos campos de login e senha.

Neste ambiente, todas as mensagens de e-mail são capturadas pelo [MailHog](https://github.com/mailhog/MailHog) e você pode visualiá-las no endereço **http://localhost:8025**.

Agora você pode modificar o código desta instância-base para implementar seus próprios requisitos.
