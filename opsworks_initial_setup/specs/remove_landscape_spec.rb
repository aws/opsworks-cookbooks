require 'minitest/spec'

describe_recipe 'opsworks_initial_setup::remove_landscape' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'must remove all landscape packages' do
    node[:opsworks_initial_setup][:landscape][:packages_to_remove].each do |pkg|
      package(pkg).wont_be_installed
    end
  end
end
