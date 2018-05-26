---
title: "Certbot: Unexpected Error"
author: bramp
date: 2018-05-26T11:28:44-07:00
layout: post
categories:
  - Blog
tags:
  - certbot
  - linux
  - letsencrypt
---


I got a [nice warning email](https://letsencrypt.org/docs/expiration-emails/) from [Let's Encrypt](https://letsencrypt.org/) that my cert was going to expire soon, and hadn't been renewed. I found in  `/var/log/letsencrypt/letsencrypt.log` the following error:

```
Renewal configuration file /etc/letsencrypt/renewal/mydomain.bramp.net.conf (cert: mydomain.bramp.net) produced an unexpected error: 'Namespace' object has no attribute 'dns_cloudflare_credentials'. Skipping.
```

I manually ran certbot in dry-run mode and it worked fine:

```shell
$ sudo certbot renew --dry-run
```

So this error only occurs when certbot is running as a cron job. Looking at `/etc/cron.d/certbot` I see the user runs as root, so I tried the `certbot renew --dry-run` again, but this time as the root user:

```shell
$ sudo su
root@:~$ sudo certbot renew --dry-run
```

and bam, the same error. This error somehow related to the [certbot-dns-cloudflare plugin](https://certbot-dns-cloudflare.readthedocs.io/en/latest/), which proves the ownership of the domain with a [DNS01 challenge](https://acme-python.readthedocs.io/en/latest/api/challenges.html#acme.challenges.DNS01) via Cloudflare's DNS. I use this form of challenge, because the domain in question is internal and not available on the Internet.

I had forgotten how I installed the plugin, but searching Google, it seems to be via `pip3`. Clearly something was different between my root and normal user w/ sudo environments. So I did the following

```shell
$ sudo pip3 list | grep certbot
certbot (0.23.0)
certbot-apache (0.23.0)
certbot-dns-cloudflare (0.24.0)

$ sudo su
root@:~$ pip3 list | grep certbot
certbot (0.23.0)
certbot-apache (0.23.0)
```

Aha, no certbot-dns-cloudflare when running as root. Clearly I hadn't installed this correctly. Running `pip3 install certbot-dns-cloudflare` as root fixed the problem, and voila, certbot correctly fetches new certs via a regular cron.
