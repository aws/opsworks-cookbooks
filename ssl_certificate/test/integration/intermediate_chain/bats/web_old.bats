#!/usr/bin/env bats

CIPHER_OLD_ONLY='ECDHE-RSA-DES-CBC3-SHA:ECDHE-ECDSA-DES-CBC3-SHA:'
CIPHER_ALL='ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:'

if [ -d /etc/httpd ]
then
  APACHE_DIR='/etc/httpd'
else
  APACHE_DIR='/etc/apache2'
fi

@test "sets old web configuration" {
  grep -F '# Old backward compatibility' "${APACHE_DIR}"/sites-enabled/*
}

@test "sets old web ssl protocol" {
  grep 'SSLProtocol all -SSLv2$' "${APACHE_DIR}"/sites-enabled/*
}

@test "includes minimum web ssl cipher suite" {
  grep "SSLCipherSuite .*${CIPHER_ALL}" "${APACHE_DIR}"/sites-enabled/*
}

@test "includes old web ssl cipher suite" {
  grep "SSLCipherSuite .*${CIPHER_OLD_ONLY}" "${APACHE_DIR}"/sites-enabled/*
}
