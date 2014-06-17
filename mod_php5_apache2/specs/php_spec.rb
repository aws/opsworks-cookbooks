require 'minitest/spec'

describe_recipe 'mod_php5_apache2::php' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it "creates the application's SSL files" do
    node[:deploy].each do |application, deploy|
      if deploy[:application_type] == 'php' && deploy[:ssl_support]
        file("#{node[:apache][:dir]}/ssl/#{deploy[:domains].first}.crt").must_exist.with(:mode, '0600')
        file("#{node[:apache][:dir]}/ssl/#{deploy[:domains].first}.key").must_exist.with(:mode, '0600')
        file("#{node[:apache][:dir]}/ssl/#{deploy[:domains].first}.ca").must_exist.with(:mode, '0600') if deploy[:ssl_certificate_ca]
      end
    end
  end

  it "rename the systems default apache configuration if present" do
    node[:deploy].each do |application, deploy|
      if deploy[:application_type] == 'php'
        file("#{node[:apache][:dir]}/sites-enabled/000-default").wont_exist
        file("#{node[:apache][:dir]}/sites-enabled/000-default.conf").wont_exist
      end
    end
  end
end
