maintainer "Josh Starcher"
description "Run sidekiq using monit"
version "0.1"
supports "ubuntu", ">= 8.10"

recipe "sidekiq::default", "Reload monit and restart sidekiq"
recipe "sidekiq::restart", "Restart sidekiq"

