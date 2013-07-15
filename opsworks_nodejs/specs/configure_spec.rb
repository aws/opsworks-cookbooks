require "minitest/spec"

describe_recipe "opsworks_nodejs::configure" do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it "install the default opsworks.js for each node app" do
    node["deploy"].each do |application, deploy|
      next unless deploy["application_type"] == "nodejs"
      config = File.join("#{deploy[:deploy_to]}", "shared/config/opsworks.js")
      file(config).must_exist.with(:mode, "0660").and(:owner, "#{deploy[:user]}").and(:group, "#{deploy[:group]}")
      file(config).must_match(/^exports.db\ =\ #{deploy[:database].to_json}/)
      file(config).must_match(/^exports.memcached\ =\ #{deploy[:memcached].to_json}/)
    end
  end
end
