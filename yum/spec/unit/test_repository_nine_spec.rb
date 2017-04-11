require 'spec_helper'

describe 'yum_test::test_repository_nine' do
  let(:test_repository_nine_run) do
    ChefSpec::Runner.new(
      :step_into => 'yum_repository'
      ).converge(described_recipe)
  end

  let(:test_repository_nine_template) do
    test_repository_nine_run.template('/etc/yum.repos.d/test9.repo')
  end

  let(:test_repository_nine_content) do
    'Hello there, I am a custom template.
baseurl: http://drop.the.baseurl.biz
Have a nice day.
'
  end

  context 'creating a yum_repository with minimal parameters' do
    it 'creates yum_repository[test9]' do
      expect(test_repository_nine_run).to create_yum_repository('test9')
        .with(
        :source => 'custom_template.erb',
        :description => 'an test',
        :baseurl => 'http://drop.the.baseurl.biz',
        :enabled => false
        )
    end

    it 'steps into yum_repository and upgrades package[ca-certificates]' do
      expect(test_repository_nine_run).to upgrade_package('ca-certificates')
    end

    it 'steps into yum_repository and creates template[/etc/yum.repos.d/test9.repo]' do
      expect(test_repository_nine_run).to create_template('/etc/yum.repos.d/test9.repo')
        .with(
        :path => '/etc/yum.repos.d/test9.repo',
        :source => 'custom_template.erb'
        )
    end

    it 'steps into yum_repository and renders file[/etc/yum.repos.d/test9.repo]' do
      expect(test_repository_nine_run).to render_file('/etc/yum.repos.d/test9.repo')
        .with_content(test_repository_nine_content)
    end

    it 'steps into yum_repository and runs execute[yum-makecache-test9]' do
      expect(test_repository_nine_run).to_not run_execute('yum-makecache-test9')
        .with(
        :command => 'yum -q makecache --disablerepo=* --enablerepo=test9'
        )
    end

    it 'steps into yum_repository and runs ruby_block[yum-cache-reload-test9]' do
      expect(test_repository_nine_run).to_not run_ruby_block('yum-cache-reload-test9')
    end

    it 'sends a :run to execute[yum-makecache-test9]' do
      expect(test_repository_nine_template).to notify('execute[yum-makecache-test9]')
    end

    it 'sends a :create to ruby_block[yum-cache-reload-test9]' do
      expect(test_repository_nine_template).to notify('ruby_block[yum-cache-reload-test9]')
    end
  end

end
