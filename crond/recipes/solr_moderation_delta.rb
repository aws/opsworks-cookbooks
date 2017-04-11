cron "solr-similar-moderation" do
  action node.tags.include?('solr-similar-moderation') ? :create : :delete
  minute '*/1'
  hour '*'
  weekday '*'
  user "deploy"
  mailto "asilva@estantevirtual.com.br"
  home "/opt/solr-5.2.1/server"
  command %w{
    export RAILS_ENV=staging &&
    cd /srv/www/praga/current &&
    wget -q http://54.84.134.136:8983/solr/similar_moderation/dataimport
  }.join(' ')
end
