require 'minitest/spec'

describe_recipe 'scalarium_initial_setup::zsh' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'installs zsh' do
    package('zsh').must_be_installed
  end

  it 'gives us /bin/zsh' do
    file('/bin/zsh').must_exist
  end
end
