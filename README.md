# Cloudflare dns update
Allows me to update my Cloudflare DNS record so that I can have access to my server with a dynamic IP

Since I have a dynamic IP at home, but have setup myself with a little web server I needed a way to have nice domain to access it and not worry about the IP changes. 
There are many great options out there such as ddns or noip, but why pay for something or go trough the trouble of confirming your account should you choose the free 
version when you can create your own script that would mimic the actions of those clients.

Also the good thing about this is that you can use it for any of your domains / sub domains hosted trough Cloudflare and not having to pick one of those free domains. 

However, if you use dedicated hardware (e.g. a router or NAS), they usually support only a fixed range of dnydns providers - cloudflare is usually not among the options. 
If nothing is pre-defined, there are many open source dyndns clients out there. Some don't run on all plattforms, most come with dependencies. 
Besides their specific libraries, of course, the most painful dependency is systemd which is typically only available to full-grown linux servers.

In my case, I run it on my QNAP NAS in Container station. This saves me the trouble of ssh-ing into the box, placing the script somwehre and to modify the crontab.
This way its maintainable and in plain sight.

***Configuration***

To set up, create an environment file `.env` alongside `docker-compose.yml`. See `Dockerfile` for hints on how to fill in these values.
``
CF_ZONE_ID=<your zone id>
CF_DNS_RECORD_ID=<dns record id>
CF_DNS_DOMAIN=<dns domain name>
CF_API_TOKEN=<your api token>
``
***Building***

`docker-compose build`

***Running***

`docker-compose up`

If you dont want to deploy on docker, the script may be run standalone but requires `curl`, `bind-tools` and `jq` 

***Requirements:***
- Basic knowledge of shell scripting, Docker
- Your domain nameservers pointing to Cloudflare
- Docker Daemon (or something like QNAP Container Station, Synology Docker)

***NOTE:***
***I take no responsibility*** should this script break your dns records and/or anything else. By using it, you acknowledge that you understand what this script does and how it may affect you in any way.
