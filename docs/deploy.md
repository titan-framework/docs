---
layout: page
title: Deploy
subtitle: Publicando sua instância.
comments: true
---

Uma vez que tenha [configurado seu ambiente de _deploy_](/docs/environment), utilize o _script_ de instalação de instâncias para publicar a aplicação:

```bash
php /var/www/titan/update/install.php git@your.git.host.com:group/repository.git /var/www/app branch-name
```

Repare que o _script_ encontra-se na pasta 'update' do _core_ do Titan, que por padrão é colocado na pasta '**/var/www/titan**'. Corrija este caminho caso tenha instalado o _core_ em algum outro local.

O _script_ funciona apenas com instância em repositórios **GIT**. Registre a _SSH key_ para acesso direto do servidor ao repositório GIT, pois isto possibilitará depois a ativação do [sistema de _auto-deploy_](/docs/auto-deploy) do Titan (veja como fazer no [GitHub](https://help.github.com/articles/connecting-to-github-with-ssh/) e no [GitLab](https://docs.gitlab.com/ce/ssh/README.html)).

O caminho onde a aplicação será instalada é, por padrão, "**/var/www/app**". Você pode alterar este caminho no comando acima, mas neste caso deverá alterar também na configuração do [Nginx](http://nginx.com).

O último parâmetro é o nome da _branch_ no GIT que o _script_ irá considerar. Ele irá procurar a _tag_ mais recente nesta _branch_ e irá instanciar esta revisão (e não a _head revision_).
