describe_recipe 'elasticsearch::proxy' do

  include MiniTest::Chef::Assertions
  include MiniTest::Chef::Context
  include MiniTest::Chef::Resources

  cluster_url = 'http://localhost:9200'
  health_url  = "#{cluster_url}/_cluster/health"

  proxy_url   = "http://USERNAME:PASSWORD@localhost:8080"

  it "runs as a daemon" do
    service("nginx").must_be_running
  end

  it "has a username in passwords file" do
    file("/usr/local/etc/elasticsearch/passwords").must_exist.must_include("USERNAME")
  end

  it "proxies request to elasticsearch" do
    timeout = 120
    until system("curl --silent --show-error '#{health_url}?wait_for_status=yellow&timeout=1m' > /dev/null") or timeout == 0
      sleep 1
      timeout -= 1
    end

    response = nil

    Net::HTTP.start('localhost', 8080) do |http|
      req = Net::HTTP::Get.new('/')
      req.basic_auth 'USERNAME', 'PASSWORD'
      response = http.request(req)
    end

    assert_equal "200", response.code
  end

end
