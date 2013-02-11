require 'minitest/spec'

describe_recipe 'mod_php5_apache2::php' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it "creates the application's cretificate" do
    if deploy[:application_type] = 'php'
      file("#{node[:apache][:dir]}/ssl/#{deploy[:domains].first}.crt").must_exist.with(:mode, '0600')
    end
  end

  it "creates the application's certificate key" do
    if deploy[:application_type] = 'php'
      file("#{node[:apache][:dir]}/ssl/#{deploy[:domains].first}.key").must_exist.with(:mode, '0600')
    end
  end

  it "creates the application's certificate chain file" do
    if deploy[:application_type] = 'php'
      file("#{node[:apache][:dir]}/ssl/#{deploy[:domains].first}.ca").must_exist.with(:mode, '0600')
    end
  end

  it "rename the systems default apache configuration if present" do
    if deploy[:application_type] = 'php'
      file("#{node[:apache][:dir]}/sites-enabled/000-default").must_not_exists
      file("{node[:apache][:dir]}/sites-enabled/zzz-default").must_exist
    end
  end
end
