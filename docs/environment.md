---
layout: page
title: Deployment Environment
subtitle: Configurando o ambiente de deploy de instâncias.
comments: true
---

O Titan Framework é homologado para rodar em sistemas [Debian](http://debian.org) e derivados (como [Ubuntu](http://ubuntu.com)). Recomenda-se o uso do servidor web [Nginx](http://nginx.com) com [PHP 7 FPM](http://php.net) e [PostgreSQL 9](http://postgresql.org) ou superior.

Há um _script_ de preparação do ambiente. Para utilizá-lo, basta configurar um servidor [Debian Jessie](http://debian.org/distrib/) com acesso à internet e executar o seguinte comando:

```bash
wget -O - http://titanframework.com/environment/prepare.sh | bash
```
Este _script_ configura um ambiente otimizado para o Titan Framework, incluindo todos os pacotes opcionais para uso pleno de todas as funcionalidades.
