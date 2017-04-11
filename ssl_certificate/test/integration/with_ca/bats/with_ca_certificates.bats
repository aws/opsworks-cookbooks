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

@test "creates a certificate with a CA" {
  [ -f "${CERT_PATH}/test.com.pem" ]
}

@test "the certificate with a CA has the correct issuer" {
  openssl x509 -in "${CERT_PATH}/test.com.pem" -noout -text \
    | grep -F 'Issuer: C=FR, ST=Ile de Paris, L=Paris, O=Toto, OU=Titi, CN=ca.test.com/emailAddress=titi@test.com'
}

@test "the certificate with a CA has the correct subject" {
  openssl x509 -in "${CERT_PATH}/test.com.pem" -noout -text \
    | grep -F 'Subject: C=FR, ST=Ile de Paris, L=Paris, O=Toto, OU=Titi, CN=test.com/emailAddress=titi@test.com'
}

@test "creates the certificate key with a CA" {
  openssl rsa -in "${KEY_PATH}/test.com.key" -text -noout
}

@test "creates a CA certificate from a data bag" {
  [ -f "${CERT_PATH}/ca.example.org.pem" ]
}

@test "the CA certificate has the correct issuer" {
  openssl x509 -in "${CERT_PATH}/ca.example.org.pem" -noout -text \
    | grep -F 'Issuer: C=ES, ST=Bizkaia, L=Bilbao, O=Conquer the World, OU=Everything, CN=ca.example.org/emailAddress=everything@example.org'
}

@test "the CA certificate has the correct issuer" {
  openssl x509 -in "${CERT_PATH}/ca.example.org.pem" -noout -text \
    | grep -F 'Subject: C=ES, ST=Bizkaia, L=Bilbao, O=Conquer the World, OU=Everything, CN=ca.example.org/emailAddress=everything@example.org'
}

@test "creates the CA certificate key with a CA" {
  openssl rsa -in "${KEY_PATH}/ca.example.org.key" -text -noout
}

@test "creates a certificate with a CA from a data bag" {
  [ -f "${CERT_PATH}/example.org.pem" ]
}

@test "the certificate with a CA has the correct issuer" {
  openssl x509 -in "${CERT_PATH}/example.org.pem" -noout -text \
    | grep -F 'Issuer: C=ES, ST=Bizkaia, L=Bilbao, O=Conquer the World, OU=Everything, CN=ca.example.org/emailAddress=everything@example.org'
}

@test "creates a certificate key with a CA from a data bag" {
  openssl rsa -in "${KEY_PATH}/example.org.key" -text -noout
}
