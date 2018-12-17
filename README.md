# Docker for Dev

This is a simple dev environment using `docker-compose`. Essentially, it's a preconfigured jwilder/nginx-proxy that handles HTTPS and domain names and all that sorta stuff. Note that this is based on a Windows 10 environment.

# Prerequisites

1. [Docker CE for Windows](https://docs.docker.com/docker-for-windows/install/)
2. [Git Bash for Windows](https://gitforwindows.org/)

# Assumptions
* Windows 10
* Chrome as browser
* Use Git Bash in Admin mode

# Setup

1. Open up Git Bash so you have a nice bash terminal on Windows.
2. Run `setup.sh`. You can change the variables in `.env` if you wish. By default, the SSL certs will be for `.me.local`.
3. Make the generated certificate inside `certs` trusted, using the following:
   1. Run `Ctrl+R` and type in `certmgr.msc`, and press enter.
   2. Under `Trusted Root Certification Authorities -> Certificates`, right click and select `All Tasks -> Import`.
   3. Using the wizard, add the generated `.crt` file in the `certs` directory under `Trusted Root Certification Authorities`.
4. Run `docker-compose up -d`
5. Now visit `https://example.me.local/`. It should have the trusted green thing.

# Adding projects
A project named "exampleweb" is included in the docker-compose file by default. Aside from the defaults, it just needs an exposed port and hostname, set as follows:

```
project_name:
   ...
   environment:
      VIRTUAL_HOST: projectname.me.local
      VIRTUAL_PORT: 80
   expose:
      - "80"
```

Run `add-to-hosts.sh` to add hostnames to the system `hosts` file. Only enter the subdomain here, it'll get appended with the `DOMAIN` value in `.env`.

A PHP project is also included in `example-php`. In that directory, just run `docker-compose up -d` and run the `add-to-hosts.sh` script and type in `php` as the hostname. That's it.

# Considerations
* A single tld CA just isn't accepted by Chrome for some reason, such as `*.local`.
* `dev` is considered by Chrome to be an actual TLD, don't use it.
* Git Bash has some issues when running Docker commands.
  * The main one is exec-ing into the Docker container. The command used should be `winpty docker exec -it CONTAINER_ID //bin//bash`

# References
* https://dev.to/domysee/setting-up-a-reverse-proxy-with-nginx-and-docker-compose-29jg
* https://github.com/jwilder/nginx-proxy
