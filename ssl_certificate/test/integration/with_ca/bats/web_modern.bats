#!/usr/bin/env bats

CIPHER_OLD_ONLY='ECDHE-RSA-DES-CBC3-SHA:ECDHE-ECDSA-DES-CBC3-SHA:'
CIPHER_INTERMEDIATE='AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:'
CIPHER_ALL='ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:'

if [ -d /etc/httpd ]
then
  APACHE_DIR='/etc/httpd'
else
  APACHE_DIR='/etc/apache2'
fi

@test "sets modern web configuration" {
  grep -F '# Modern compatibility' "${APACHE_DIR}"/sites-enabled/*
}

@test "sets modern web ssl protocol" {
  grep 'SSLProtocol all -SSLv2 -SSLv3 -TLSv1$' "${APACHE_DIR}"/sites-enabled/*
}

@test "sets modern web ssl cipher suite" {
  grep -F 'SSLCipherSuite ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:' "${APACHE_DIR}"/sites-enabled/*
}

@test "includes minimum web ssl cipher suite" {
  grep "SSLCipherSuite .*${CIPHER_ALL}" "${APACHE_DIR}"/sites-enabled/*
}

@test "does not include old web ssl cipher suite" {
  ! grep "SSLCipherSuite .*${CIPHER_OLD_ONLY}" "${APACHE_DIR}"/sites-enabled/*
}

@test "does not include intermediate web ssl cipher suite" {
  ! grep "SSLCipherSuite .*${CIPHER_INTERMEDIATE}" "${APACHE_DIR}"/sites-enabled/*
}
