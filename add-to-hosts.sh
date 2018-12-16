#!/usr/bin/env bash
source .env
while read -p "Enter domain to add to hosts file (enter empty line to exit): " HOSTURL; do
    if [ -z $HOSTURL ]; then
        break
    fi
    printf "\n127.0.0.1 $HOSTURL.$DOMAIN" >> /c/Windows/System32/drivers/etc/hosts
done