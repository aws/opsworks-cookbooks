#!/usr/bin/env bats

@test "creates the apache2 virtualhost" {
  echo | openssl s_client -connect 127.0.0.1:443 \
    | grep -F 'subject=/C=FR/ST=Ile de Paris/L=Paris/O=Toto/OU=Titi/CN=test.com/emailAddress=titi@test.com'
}
