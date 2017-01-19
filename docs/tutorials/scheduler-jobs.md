---
layout: page
title: Scheduler Jobs
subtitle: Execução programada de scripts.
comments: true
---

Já era possível agendar a execução de tarefas (_scheduler jobs_) no Titan por meio a chamadas a _scripts_ ('**titan.php?target=script**'), entretanto, por organização e segurança, foi implementado um procedimento oficial para a execução periódica de _scripts_.

O primeiro passo é configurar uma hash de segurança no '**titan.xml**' adicionando uma _tag_ no seguinte formato:

```xml
<schedule hash="cadeia_de_caracteres_aleatória" />
```

Gere uma cadeia de caracteres aleatória e substitua no local indicado.

Ao criar um novo componente o desenvolvedor pode agora criar uma pasta mandatória denominada '**_job_**'. Dentro dela é possível colocar os _scripts_ que executarão periódicamente. É recomendado que o nome do _script_ remeta à sua frequência de execução, por exemplo: '**daily.php**', '**weekly.php**', '**hourly.php**', etc.

Agora, deve-se colocar a chamada aos _jobs_ em algum "_time-based job scheduler_", como o [CRON](https://en.wikipedia.org/wiki/Cron) nos sistemas _unix-like_. Por exemplo, a linha do '**crontab**' com a chamada a um job '**daily**' em uma instância hospedada em "[https://www.minha-instancia.com/](https://www.minha-instancia.com/)" em um servidor FreeBSD ficaria:

```bash
0  3  *  *  *  root	/usr/local/bin/wget --no-check-certificate "https://www.minha-instancia.com/titan.php?target=schedule&hash=cadeia_de_caracteres_aleatória=daily" -O /dev/null -o /dev/null
```

Esta linha nada mais faz do que utilizar o [wget](https://en.wikipedia.org/wiki/Wget) para abrir a página que executa o _job_. O parâmetro '**--no-check-certificate**' é passado apenas por se tratar de uma requição '**https**'. Nesta configuração o _job_ será executado **todo dia às 3:00h da manhã**.

Reparem que toda a saída é enviada para "**/dev/null**" pois ela é irrelevante. Os erros e saídas são gavados em "**[cache]/job/[nome do job].yyyymmdd**". Assim, para que seja gravado no LOG qualquer saída, basta imprimí-la com '**echo**'. É necessário passar na _query string_ a mesma _hash_ configurada no '**titan.xml**'.
