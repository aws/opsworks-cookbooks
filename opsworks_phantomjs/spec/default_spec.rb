require 'spec_helper'

describe 'phantomjs::default' do
  context 'on ubuntu' do
    before{ Fauxhai.mock(platform:'ubuntu') }
    let(:runner){ ChefSpec::ChefRunner.new.converge('phantomjs::default') }

    it 'should install the correct packages' do
      runner.should install_package 'fontconfig'
      runner.should install_package 'libfreetype6'
    end
  end

  context 'on centos' do
    before{ Fauxhai.mock(platform:'centos') }
    let(:runner){ ChefSpec::ChefRunner.new.converge('phantomjs::default') }

    it 'should install the correct packages' do
      runner.should install_package 'fontconfig'
      runner.should install_package 'freetype'
    end
  end

  let(:runner) do
    ChefSpec::ChefRunner.new.converge('phantomjs::default')
  end

  it 'should fetch the correct remote_file' do
    runner.should create_remote_file '/usr/local/src/phantomjs-1.9.0-linux-i386.tar.bz2'
  end

  it 'should extract the binary' do
    runner.should execute_command 'tar -xvjf /usr/local/src/phantomjs-1.9.0-linux-i386.tar.bz2 -C /usr/local/'
  end

  it 'should symlink the binary to /usr/local/bin' do
    runner.should create_link '/usr/local/bin/phantomjs'
    runner.link('/usr/local/bin/phantomjs').should link_to('/usr/local/phantomjs-1.9.0-linux-i386/bin/phantomjs')
  end
end
