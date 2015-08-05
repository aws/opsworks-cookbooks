cron "solr-search-delta" do
  #action node.tags.include?('solr-search-delta') ? :create : :delete
  minute '*/1'
  hour '*'
  weekday '*'
  user "deploy"
  mailto "ti@estantevirtual.com.br"
  home "/opt/solr-5.2.1/server"
  command %w{
    wget -q "http://127.0.0.1:8983/solr/search/dataimport?&optimze=true&command=delta-import&wt=json"
  }.join(' ')
end
