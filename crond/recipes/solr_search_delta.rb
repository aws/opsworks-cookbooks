cron "solr-search-delta" do
  action node.tags.include?('solr-search-delta') ? :create : :delete
  minute '*/1'
  hour '*'
  weekday '*'
  user "deploy"
  mailto "asilva@estantevirtual.com.br"
  home "/opt/solr-5.2.1/server"
  command %w{
    wget -q http://52.2.195.49:8983/solr/dataimport?&command=delta-import&wt=json
  }.join(' ')
end
