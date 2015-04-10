describe_recipe 'elasticsearch::aws' do

  include MiniTest::Chef::Assertions
  include MiniTest::Chef::Context
  include MiniTest::Chef::Resources

  cluster_url = 'http://localhost:9200'
  health_url  = "#{cluster_url}/_cluster/health"

  proxy_url   = "http://USERNAME:PASSWORD@localhost:8080"


  it "creates the directory" do
    if node.recipes.include?("elasticsearch::aws")
      directory("/usr/local/elasticsearch/plugins/cloud-aws/").must_exist.with(:owner, 'elasticsearch')
    end
  end

  # Pending...
  # it "loads the plugin" do
  #   if node.recipes.include?("elasticsearch::aws")
  #     system("service elasticsearch restart")
  #     timeout = 120
  #     until system("curl --silent --show-error '#{health_url}' > /dev/null 2>&1") or timeout == 0
  #       sleep 1
  #       timeout -= 1
  #     end
  #     file('/usr/local/var/log/elasticsearch/elasticsearch_vagrant.log').must_match /loaded.*\[cloud\-aws\]$/
  #   end
  # end

end
