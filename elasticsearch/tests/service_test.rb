describe_recipe 'elasticsearch::default' do

  include MiniTest::Chef::Assertions
  include MiniTest::Chef::Context
  include MiniTest::Chef::Resources

  it "runs as a daemon" do
    service("elasticsearch").must_be_running
  end

  it "boots on startup" do
    service("elasticsearch").must_be_enabled
  end

end
