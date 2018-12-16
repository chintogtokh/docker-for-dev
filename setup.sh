#!/usr/bin/env bash
source .env

docker network create nginx-proxy

#Based on https://github.com/jfrog/artifactory-scripts/blob/master/docker/httpd/ssl-wildcard/wildcard-ssl.sh

# Create certs directory
[ -d certs ] || mkdir certs

# Generate conf file
OpenSSLConf="$DOMAIN"-openssl.cnf

cat >"$OpenSSLConf" <<EOL
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name

[ req_distinguished_name ]
countryName                 = Country
countryName_default         = AU
stateOrProvinceName         = State
stateOrProvinceName_default = VIC
localityName                = City
localityName_default        = Melbourne
commonName                  = DockerForDev
commonName_default          = DockerForDev

[ v3_req ]
basicConstraints = CA:TRUE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = $DOMAIN
DNS.2 = *.$DOMAIN
EOL

# Create Private RSA Key
openssl genrsa -out "certs/$DOMAIN".key 1024

# Create Certificate Signing Request
openssl req -new -key "certs/$DOMAIN".key -out "certs/$DOMAIN".csr -config "$OpenSSLConf"

# Create Certifcate
openssl x509 -req -days 365 -in "certs/$DOMAIN".csr \
-signkey "certs/$DOMAIN".key -out "certs/$DOMAIN".crt \
-extensions v3_req \
-extfile "$OpenSSLConf"

# Cleanup
rm -- "$OpenSSLConf"

# Add to hosts
printf "\n127.0.0.1 exampleweb.$DOMAIN" >> /c/Windows/System32/drivers/etc/hosts