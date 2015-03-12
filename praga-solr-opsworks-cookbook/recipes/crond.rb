cron "solr-index-update" do
  hour "*"
  minute "*/15"
  weekday "*"
  command "curl 'http://localhost/solr/praga/dataimport?clean=false&commit=true&command=delta-import&wt=json'"
end
