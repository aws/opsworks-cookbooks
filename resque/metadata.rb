maintainer        "Paper Cavalier"
maintainer_email  "code@papercavalier.com"
license           "Apache 2.0"
description       "Installs resque from rubygems and manages it via bluepill"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.textile'))
version           "0.1.0"

recipe "resque::default", "Installs resque from rubygems and manages it via bluepill, defaults to Capistrano setup. REE aware."
