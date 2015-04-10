describe_recipe 'elasticsearch::data' do

  include MiniTest::Chef::Assertions
  include MiniTest::Chef::Context
  include MiniTest::Chef::Resources

  it "mounts the secondary disk" do
     mount("/usr/local/var/data/elasticsearch/disk1", :device => "/dev/sdb").
       must_be_mounted \
       if node.recipes.include?("elasticsearch::data")
  end

  it "correctly creates the data directory" do
    directory("/usr/local/var/data/elasticsearch/disk1").
      must_exist.
      with(:owner, 'elasticsearch') \
      if node.recipes.include?("elasticsearch::data")
  end

end
