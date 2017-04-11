#!/usr/bin/env bats

@test "creates the apache2 virtualhost" {
  echo | openssl s_client -connect 127.0.0.1:443 \
    | grep -F '0 s:/C=AU/ST=Some-State/O=Internet Widgits Pty Ltd/CN=owncloud.local'
  echo | openssl s_client -connect 127.0.0.1:443 \
    | grep -F '1 s:/C=US/O=Internet2/OU=InCommon/CN=InCommon Server CA'
}
