require 'minitest/spec'

describe_recipe 'opsworks_initial_setup::default' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it "sets the default encoding for reading files to UTF-8" do
    assert_equal("UTF-8", Encoding.default_external.to_s)
  end
end
