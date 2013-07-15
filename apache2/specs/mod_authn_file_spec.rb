require 'minitest/spec'

describe_recipe 'apache2::mod_authn_file' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions
  before :all do
    @prefix = case node[:platform_family]
              when 'rhel'
                node[:apache][:dir]
              when "debian"
                ".."
              end
  end

  it 'enables mod_authn_file' do
    link("#{node[:apache][:dir]}/mods-enabled/authn_file.load").must_exist.with(
         :link_type, :symbolic).and(:to, "#{@prefix}/mods-available/authn_file.load")
  end
end
