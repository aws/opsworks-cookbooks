maintainer "Amazon Web Services"
description      "Installs/Configures unicorn"
version          "0.1"

%w{ dependencies nginx apache2 deploy }.each do |cb|
  depends cb
end

recipe "unicorn", "Installs unicorn rubygem"
recipe "unicorn::rails", "Setup unicorn for a rails stack"
recipe "unicorn::stop", "Stop unicorn"
