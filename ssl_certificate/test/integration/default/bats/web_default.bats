#!/usr/bin/env bats

if [ -d /etc/httpd ]
then
  APACHE_DIR='/etc/httpd'
else
  APACHE_DIR='/etc/apache2'
fi

@test "sets default web ssl protocol" {
  ! grep 'SSLProtocol' "${APACHE_DIR}"/sites-enabled/*
}

@test "sets default web ssl cipher suite" {
  ! grep -F 'SSLCipherSuite' "${APACHE_DIR}"/sites-enabled/*
}
