require 'minitest/spec'

describe_recipe 'opsworks_custom_cookbooks::berkshelf' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'creates the berkshelf-cookbooks directory' do
    if node[:opsworks_custom_cookbooks][:manage_berkshelf]
      assert_path_exists(directory(Opsworks::InstanceAgent::Environment.berkshelf_cookbooks_path))
    end
  end

  it 'removes the berkshelf-cookbooks directory' do
    unless node[:opsworks_custom_cookbooks][:manage_berkshelf]
      refute_path_exists(directory(Opsworks::InstanceAgent::Environment.berkshelf_cookbooks_path))
    end
  end
end
