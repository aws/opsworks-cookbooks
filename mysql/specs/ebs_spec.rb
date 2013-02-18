require 'minitest/spec'

describe_recipe 'mysql::ebs' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'should have directory for data' do
    directory(node[:mysql][:ec2_path]).must_exist.with(:owner, 'mysql').and(
      :group, 'mysql')
  end

  describe 'mount' do
    it 'should be mounted' do
      mount(node[:mysql][:datadir],
            :device => node[:mysql][:ec2_path]).must_be_enabled.with(
              :fstype, 'none').and(:options, ['bind', 'rw']
           )
      mount(node[:mysql][:datadir], :device => node[:mysql][:ec2_path]).must_be_mounted
    end
  end
end
