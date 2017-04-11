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

@test "creates the intermediate chains certificate" {
  # [ -f "${CERT_PATH}/dummy-ca-bundle.pem" ]
  openssl x509 -in "${CERT_PATH}/dummy-ca-bundle.pem" -text -noout
}

@test "creates chained certificate from a data bag" {
  openssl x509 -in "${CERT_PATH}/chain-data-bag.pem" -text -noout
}

@test "creates chained combined certificate from a data bag" {
  openssl x509 -in "${CERT_PATH}/chain-data-bag.pem.chained.pem" -text -noout
}

@test "creates chained certificate key from a data bag" {
  openssl rsa -in "${KEY_PATH}/chain-data-bag.key" -text -noout
}
