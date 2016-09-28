maintainer "Amazon Web Services"
description      "Installs ruby"
version          "0.1"

%w{ opsworks_rubygems opsworks_bundler }.each do |cb|
  depends cb
end

recipe "ruby", "Installs ruby"
