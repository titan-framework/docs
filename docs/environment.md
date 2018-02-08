---
layout: page
title: Deployment Environment
subtitle: Configurando o ambiente de deploy de instâncias.
comments: true
---

O Titan Framework é homologado para rodar em sistemas [Debian](http://debian.org) e derivados (como [Ubuntu](http://ubuntu.com)). Recomenda-se o uso do servidor web [Nginx](http://nginx.com) com [PHP 7 FPM](http://php.net) e [PostgreSQL 9](http://postgresql.org) ou superior.

Há um _script_ de preparação do ambiente. Para utilizá-lo, basta configurar um servidor [Debian 9 (Stretch)](http://debian.org/distrib/) com acesso à internet e executar o seguinte comando:

```bash
wget -O - http://titanframework.com/environment/prepare.sh | bash
```

Este _script_ configura um ambiente otimizado para o Titan Framework, incluindo os pacotes obrigatórios e opcionais para uso pleno de todas as funcionalidades.

Alternativamente, você pode criar um _container_ do [Docker](https://docker.com) a partir da [imagem oficial](https://hub.docker.com/r/carromeu/titan-framework) do Titan. Edite o mapeamento de portas no arquivo ```docker-compose.yml``` da raiz da instância como preferir e faça:

```bash
docker-compose up -d
```

Assim, como o _script_ mais acima, o _container_ inclui todos os pacotes obrigatórios e opcionais para uso pleno de todas as funcionalidades.
