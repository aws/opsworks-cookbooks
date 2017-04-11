#!/usr/bin/env bats

@test "creates the apache2 virtualhost" {
  echo | openssl s_client -connect 127.0.0.1:443 \
    | grep -F 'subject=/O=ssl_certificate apache2 template test/'
}
