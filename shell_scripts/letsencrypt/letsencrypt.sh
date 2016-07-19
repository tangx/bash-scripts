#!/bin/bash

# Usage: /etc/nginx/certs/letsencrypt.sh /etc/nginx/certs/letsencrypt.conf

CONFIG=$1


ACME_TINY="/tmp/acme_tiny.py"
DOMAIN_KEY=""

if [ -f "$CONFIG" ];then
    . "$CONFIG"
    DIRNAME=$(dirname "$CONFIG")
	echo "DIRNAME="$DIRNAME
    cd "$DIRNAME" || exit 1
else
    wget -c https://raw.githubusercontent.com/uyinn/bash-scripts/master/shell_scripts/letsencrypt/example.ltd.conf -o /dev/null
    echo "ERROR CONFIG."
    exit 1
fi



KEY_PREFIX="${DOMAIN_KEY%%.*}"
DOMAIN_KEY_PATH="${DOMAIN_KEY%.*}"
mkdir -p $DOMAIN_KEY_PATH
DOMAIN_KEY="$DOMAIN_KEY_PATH/$DOMAIN_KEY"
DOMAIN_CRT="$DOMAIN_KEY_PATH/$KEY_PREFIX.crt"
DOMAIN_PEM="$DOMAIN_KEY_PATH/$KEY_PREFIX.pem"
DOMAIN_CSR="$DOMAIN_KEY_PATH/$KEY_PREFIX.csr"
DOMAIN_CHAINED_CRT="$DOMAIN_KEY_PATH/$KEY_PREFIX.chained.crt"

if [ ! -f "$ACCOUNT_KEY" ];then
    echo "Generate account key..."
    openssl genrsa 4096 > "$ACCOUNT_KEY"
fi

if [ ! -f "$DOMAIN_KEY" ];then
    echo "Generate domain key..."
    if [ "$ECC" = "TRUE" ];then
        openssl ecparam -genkey -name secp256r1 | openssl ec -out "$DOMAIN_KEY"
    else
        openssl genrsa 2048 > "$DOMAIN_KEY"
    fi
fi

echo "Generate CSR...$DOMAIN_CSR"

OPENSSL_CONF="/etc/ssl/openssl.cnf"

if [ ! -f "$OPENSSL_CONF" ];then
    OPENSSL_CONF="/etc/pki/tls/openssl.cnf"
    if [ ! -f "$OPENSSL_CONF" ];then
        echo "Error, file openssl.cnf not found."
        exit 1
    fi
fi

openssl req -new -sha256 -key "$DOMAIN_KEY" -subj "/" -reqexts SAN -config <(cat $OPENSSL_CONF <(printf "[SAN]\nsubjectAltName=%s" "$DOMAINS")) > "$DOMAIN_CSR"

wget -c https://raw.githubusercontent.com/diafygi/acme-tiny/master/acme_tiny.py -O $ACME_TINY -o /dev/null

if [ -f "$DOMAIN_CRT" ];then

    # mkdir -p $DOMAIN_KEY_PATH/old/
    # mv "$DOMAIN_CRT" "$DOMAIN_KEY_PATH/old/$DOMAIN_CRT-OLD-$(date +%y%m%d-%H%M%S)"
    rm -f $DOMAIN_CRT
    
fi


DOMAIN_DIR="$DOMAIN_DIR/.well-known/acme-challenge/"


python $ACME_TINY --account-key "$ACCOUNT_KEY" --csr "$DOMAIN_CSR" --acme-dir "$DOMAIN_DIR" > "$DOMAIN_CRT"

if [ "$?" != 0 ];then
    exit 1
fi

if [ ! -f "lets-encrypt-x3-cross-signed.pem" ];then
    wget -c  https://letsencrypt.org/certs/lets-encrypt-x3-cross-signed.pem -o /dev/null
fi

if [ -f "$DOMAIN_CHAINED_CRT" ];then
    # mkdir -p $DOMAIN_KEY_PATH/old/
    mv $DOMAIN_CHAINED_CRT "${DOMAIN_CHAINED_CRT}-OLD-$(date +%y%m%d-%H%M%S)"
    cat "$DOMAIN_CRT" lets-encrypt-x3-cross-signed.pem > "$DOMAIN_CHAINED_CRT"
fi



if [ "$LIGHTTPD" = "TRUE" ];then
    cat "$DOMAIN_KEY" "$DOMAIN_CRT" > "$DOMAIN_PEM"
    echo -e "\e[01;32mNew pem: $DOMAIN_PEM has been generated\e[0m"
fi

echo -e "\e[01;32mNew cert: $DOMAIN_CHAINED_CRT has been generated\e[0m"

rm -f $DOMAIN_CRT $DOMAIN_CSR
if [ -d "$NGINX_SSL_KEY_PATH" ];then

    \cp -a  $DOMAIN_KEY_PATH/* $NGINX_SSL_KEY_PATH/ 
    /etc/init.d/nginxd reload    
    echo -e "\e[01;32mNew cert: $DOMAIN_CHAINED_CRT is working\e[0m"
    
fi



#service nginx reload
