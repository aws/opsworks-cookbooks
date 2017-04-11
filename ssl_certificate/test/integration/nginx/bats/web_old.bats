#!/usr/bin/env bats

CIPHER_INTERMEDIATE_ONLY='AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:'
CIPHER_OLD_ONLY='ECDHE-RSA-DES-CBC3-SHA:ECDHE-ECDSA-DES-CBC3-SHA:'
CIPHER_ALL='ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:'

if [ -d /usr/local/etc/nginx ]
then
  NGINX_DIR='/usr/local/etc/nginx'
else
  NGINX_DIR='/etc/nginx'
fi

@test "sets intermediate web configuration" {
  grep -F '# Intermediate compatibility' "${NGINX_DIR}"/sites-enabled/*
}

@test "sets intermediate web ssl protocol" {
  grep 'ssl_protocols TLSv1 TLSv1\.1 TLSv1\.2;$' "${NGINX_DIR}"/sites-enabled/*
}

@test "includes minimum web ssl cipher suite" {
  grep "ssl_ciphers .*${CIPHER_ALL}" "${NGINX_DIR}"/sites-enabled/*
}

@test "includes intermediate web ssl cipher suite" {
  grep "ssl_ciphers .*${CIPHER_INTERMEDIATE_ONLY}" "${NGINX_DIR}"/sites-enabled/*
}

@test "does not include old web ssl cipher suite" {
  ! grep "ssl_ciphers .*${CIPHER_OLD_ONLY}" "${NGINX_DIR}"/sites-enabled/*
}
