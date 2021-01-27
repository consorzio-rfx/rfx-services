#!/bin/bash

# Bash shell script for generating self-signed certs. Run this in a folder, as it
# generates a few files. Large portions of this script were taken from the
# following artcile:
#
# http://usrportage.de/archives/919-Batch-generating-SSL-certificates.html
#
# Additional alterations by: Brad Landers
# Date: 2012-01-27

set -x

# Script accepts a single argument, the fqdn for the cert
DOMAIN="$1"
OUTP="$2"
if [ -z "$DOMAIN" -o -z "${OUTP}"]; then
  echo "Usage: $(basename $0) <domain> <output_path>"
  exit 11
fi

gen_error() {
	unset PASSPHRASE
	exit 10
}

# Generate a passphrase
export PASSPHRASE=$(head -c 500 /dev/urandom | tr -dc a-z0-9A-Z | head -c 128; echo)

# Certificate details; replace items in angle brackets with your own info
subj="
C=${COUNTRY:=IT}
ST=${STATE:=Italy}
O=${COMPANY_NAME:=mildstone}
localityName=${CITY:=Padova}
commonName=$DOMAIN
organizationalUnitName=${DEPARTMENT_NAME:=mildstone}
emailAddress=${ADMIN_EMAIL:=andrea.rgn@gmail.com}
"

# Generate the server private key
openssl genrsa -des3 -out $OUTP/$DOMAIN.key -passout env:PASSPHRASE 2048 || gen_error

# Generate the CSR
openssl req \
	-new \
	-batch \
	-subj "$(echo -n "$subj" | tr "\n" "/")" \
	-key $OUTP/$DOMAIN.key \
	-out $OUTP/$DOMAIN.csr \
	-passin env:PASSPHRASE || gen_error
cp $OUTP/$DOMAIN.key $OUTP/$DOMAIN.key.org || gen_error

# Strip the password so we don't have to type it every time we restart Apache
openssl rsa -in $OUTP/$DOMAIN.key.org -out $OUTP/$DOMAIN.key -passin env:PASSPHRASE || gen_error

# Generate the cert (good for 10 years)
openssl x509 -req -days 3650 -in $OUTP/$DOMAIN.csr -signkey $OUTP/$DOMAIN.key -out $OUTP/$DOMAIN.crt || gen_error

