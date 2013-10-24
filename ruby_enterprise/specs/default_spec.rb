require 'minitest/spec'

describe_recipe 'ruby_enterprise::default' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  case node[:platform]
  when 'debian','ubuntu'
    describe 'debian based machines' do
      it 'removes ruby1.9' do
        # using "package" generates a failure
        refute system("dpkg --get-selections 'ruby1.9' | grep install")
      end

      it 'removes opsworks-ruby1.9' do
        # using "package" generates a failure
        refute system("dpkg --get-selections 'opsworks-ruby1.9' | grep install")
      end

      it 'creates deb file' do
        arch = RUBY_PLATFORM.match(/64/) ? 'amd64' : 'i386'
        file("/tmp/#{File.basename(node[:ruby_enterprise][:url][arch])}").must_exist
      end
    end

  when 'centos','redhat','fedora','amazon'
    describe 'redhat based machines' do
      it 'creates rpm file' do
        arch = node[:kernel][:machine]
        file("/tmp/#{File.basename(node[:ruby_enterprise][:url][arch])}").must_exist
      end

      it 'removes ruby19' do
        package('ruby19').wont_be_installed
      end

      it 'removes opsworks-ruby19' do
        package('opsworks-ruby19').wont_be_installed
      end

    end
  end

  it 'installs ruby enterprise edition' do
    package('ruby-enterprise').must_be_installed
  end

  it 'creates /etc/environment with the right variables' do
    file('/etc/environment').must_exist.with(:mode, '644').and(:owner, 'root').and(:group, 'root')
    file('/etc/environment').must_include "#{node[:ruby_enterprise][:gc][:heap_min_slots]}"
    file('/etc/environment').must_include "#{node[:ruby_enterprise][:gc][:heap_slots_increment]}"
    file('/etc/environment').must_include "#{node[:ruby_enterprise][:gc][:heap_slots_growth_factor]}"
    file('/etc/environment').must_include "#{node[:ruby_enterprise][:gc][:malloc_limit]}"
    file('/etc/environment').must_include "#{node[:ruby_enterprise][:gc][:heap_free_min]}"
  end

  it 'creates /usr/local/bin/ruby_gc_wrapper.sh with the right variables' do
    file('/usr/local/bin/ruby_gc_wrapper.sh').must_exist.with(:mode, '755').and(:owner, 'root').and(:group, 'root')
    file('/usr/local/bin/ruby_gc_wrapper.sh').must_include "#{node[:ruby_enterprise][:gc][:heap_min_slots]}"
    file('/usr/local/bin/ruby_gc_wrapper.sh').must_include "#{node[:ruby_enterprise][:gc][:heap_slots_increment]}"
    file('/usr/local/bin/ruby_gc_wrapper.sh').must_include "#{node[:ruby_enterprise][:gc][:heap_slots_growth_factor]}"
    file('/usr/local/bin/ruby_gc_wrapper.sh').must_include "#{node[:ruby_enterprise][:gc][:malloc_limit]}"
    file('/usr/local/bin/ruby_gc_wrapper.sh').must_include "#{node[:ruby_enterprise][:gc][:heap_free_min]}"
  end
end
