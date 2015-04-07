#!/usr/bin/env bats

DEB_CERT_PATH='/etc/ssl/certs'
RH_CERT_PATH='/etc/pki/tls/certs'
FB_CERT_PATH='/etc/ssl'

DEB_KEY_PATH='/etc/ssl/private'
RH_KEY_PATH='/etc/pki/tls/private'
FB_KEY_PATH='/etc/ssl'

setup() {
  if [ -d "${DEB_CERT_PATH}" ]
  then
    CERT_PATH="${DEB_CERT_PATH}"
  elif [ -d "${RH_CERT_PATH}" ]
  then
    CERT_PATH="${RH_CERT_PATH}"
  elif [ -d "${FB_CERT_PATH}" ]
  then
    CERT_PATH="${FB_CERT_PATH}"
  else
    CERT_PATH='/etc'
  fi

  if [ -d "${DEB_KEY_PATH}" ]
  then
    KEY_PATH="${DEB_KEY_PATH}"
  elif [ -d "${RH_KEY_PATH}" ]
  then
    KEY_PATH="${RH_KEY_PATH}"
  elif [ -d "${FB_KEY_PATH}" ]
  then
    KEY_PATH="${FB_KEY_PATH}"
  else
    KEY_PATH='/etc'
  fi
}

@test "creates dummy1 certificate" {
  openssl x509 -in "${CERT_PATH}/dummy1.pem" -text -noout
}

@test "creates dummy1 certificate key" {
  openssl rsa -in "${KEY_PATH}/dummy1.key" -text -noout
}

@test "creates dummy2 certificate" {
  openssl x509 -in "${CERT_PATH}/dummy2.pem" -text -noout
}

@test "creates dummy2 certificate key" {
  openssl rsa -in "${KEY_PATH}/dummy2.key" -text -noout
}

@test "creates dummy3 certificate" {
  openssl x509 -in "${CERT_PATH}/dummy3.pem" -text -noout
}

@test "creates dummy3 certificate key" {
  openssl rsa -in "${KEY_PATH}/dummy3.key" -text -noout
}

@test "sets dummy4 certificate country" {
  openssl x509 -in "${CERT_PATH}/dummy4.pem" -text -noout \
    | grep -F 'C=Bilbao'
}

@test "creates dummy4 certificate key" {
  openssl rsa -in "${KEY_PATH}/dummy4.key" -text -noout
}

@test "creates dummy5 certificate from a data bag" {
  openssl x509 -in "${CERT_PATH}/dummy5-data-bag.pem" -text -noout \
    | grep -F 'C=AU, ST=Some-State, O=Internet Widgits Pty Ltd'
}

@test "creates dummy5 certificate key from a data bag" {
  openssl rsa -in "${KEY_PATH}/dummy5-data-bag.key" -text -noout
}

@test "creates dummy6 certificate from node attributes" {
  openssl x509 -in "${CERT_PATH}/dummy6-attributes.pem" -text -noout \
    | grep -F 'C=AU, ST=Some-State, O=Internet Widgits Pty Ltd'
}

@test "creates dummy6 certificate key from node attributes" {
  openssl rsa -in "${KEY_PATH}/dummy6-attributes.key" -text -noout
}
