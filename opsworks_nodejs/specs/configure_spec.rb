require 'minitest/spec'

describe_recipe 'opsworks_nodejs::configure' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it "install the default opsworks.js" do
    config = File.join("#{deploy[:deploy_to]}",'shared/config/opsworks.js')
    file( config ).must_exist.with(
         :mode, '0660').and(:owner, "#{deploy[:user]}").and(:group, "#{deploy[:group]}")
    file( config ).must_match(/^exports.db\ =\ Regexp.escape(deploy[:database])/)
    file( config ).must_match(/^exports.memcached\ =\ Regexp.escape(deploy[:memcached])/)
  end
end
