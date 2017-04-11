cron "solr-index-update" do
  action node.tags.include?('solr-index-update') ? :create : :delete
  minute '*/15'
  hour '*'
  weekday '*'
  user "deploy"
  mailto "asilva@estantevirtual.com.br"
  home "/srv/www/praga/current"
  command %w{
    export RAILS_ENV=staging && 
    cd /srv/www/praga/current && 
    bundle exec rake cache:clean solr:update_index['full-import']
  }.join(' ')
end
