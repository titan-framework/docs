---
layout: page
title: Quickstart
subtitle: Instanciando em 3 minutos sua aplicação.
comments: true
---

Para instanciar sua primeira aplicação, utilize o [Composer](https://getcomposer.org):

```bash
composer create-project titan-framework/instance path/to/local/folder
```

Após finalizar o comando acima, inicialize a *box* do [Vagrant](https://vagrantup.com) para executar sua aplicação:

```bash
cd path/to/local/folder
vagrant up
```

Ao término, sua instância estará rodando em **http://localhost:8090**. Para acessá-la, utilize "**admin**" nos campos de login e senha.

Neste ambiente, todas as mensagens de e-mail são capturadas pelo [MailHog](https://github.com/mailhog/MailHog) e você pode visualiá-las no endereço **http://localhost:8025**.

Você pode acessar o _shell_ da máquina virtual utilizando SSH em **localhost:2222**.

Você também pode utilizar o [Docker](https://docker.com) pra criar um _container_ com todos os requisitos (obrigatórios e opcionais). Edite o mapeamento de portas no arquivo ```docker-compose.yml``` como preferir e faça:

```bash
docker-compose up -d
```

Agora você pode modificar o código desta instância-base para implementar seus próprios requisitos. Para isso, consulte a [documentacão](/docs/preface) na íntegra do *framework*.
