cron_d "solr-index-update" do
  hour "*"
  minute "*/15"
  weekday "*"
  command "export RAILS_ENV=staging&& cd /srv/www/praga/current && bundle exec rake cache:clean solr:update_index['full-import']"
end
