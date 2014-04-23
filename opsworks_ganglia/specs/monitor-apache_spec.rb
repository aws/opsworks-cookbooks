require 'minitest/spec'

describe_recipe 'opsworks_ganglia::monitor-apache' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'creates /etc/ganglia/conf.d/apache.pyconf' do
    file('/etc/ganglia/conf.d/apache.pyconf').must_exist.with(:mode, '644')
  end

  it 'creates Apache python module' do
   apache_python_module_file = case node["platform"]
                               when 'centos','redhat','fedora','amazon'
                                 "/usr/#{RUBY_PLATFORM.match(/64/) ? 'lib64' : 'lib'}/ganglia/python_modules/apache.py"
                               when 'debian','ubuntu'
                                 '/usr/lib/ganglia/python_modules/apache.py'
                               end

    file(apache_python_module_file).must_exist.with(:mode, '644')
  end
end
