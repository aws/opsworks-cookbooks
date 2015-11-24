#!/usr/bin/env rake

#
# Berkshelf
#
desc 'Install berkshelf cookbooks locally'
task :berkshelf do
  system('berks install')
  system('berks update')
end

# Style tests. Rubocop and Foodcritic
namespace :style do
  begin
    require 'foodcritic'

    desc 'Run Chef style checks'
    task :foodcritic do
      FoodCritic::Rake::LintTask.new(:chef) do |t|
        puts 'Running Foodcritic...'
        t.options = {
          fail_tags: ['any']
        }
      end
    end
  rescue LoadError
    puts '>>>>> foodcritic gem not loaded, omitting tasks' unless ENV['CI']
  end

  begin
    require 'rubocop/rake_task'
    desc 'Run Ruby style checks'
    RuboCop::RakeTask.new(:ruby)
  rescue LoadError
    puts '>>>>> Rubocop gem not loaded, omitting tasks' unless ENV['CI']
  end
end

namespace :unit do
  begin
    require 'rspec/core/rake_task'
    desc 'Runs specs with chefspec.'
    RSpec::Core::RakeTask.new(:rspec)
  rescue LoadError
    puts '>>>>> chefspec gem not loaded, omitting tasks' unless ENV['CI']
  end
end

# Integration tests. Kitchen.ci
namespace :integration do
  begin
    desc 'Run integration tests with kitchen-vagrant'
    task :vagrant do
      require 'kitchen'
      Kitchen.logger = Kitchen.default_file_logger
      Kitchen::Config.new.instances.each do |instance|
        instance.test(:always)
      end
    end
  rescue LoadError
    puts '>>>>> kitchen gem not loaded, omitting tasks' unless ENV['CI']
  end

  begin
    desc 'Run integration tests with kitchen-docker'
    task :docker do
      ENV['KI_DRIVER'] = 'docker'
      require 'kitchen'
      Kitchen.logger = Kitchen.default_file_logger
      Kitchen::Config.new.instances.each do |instance|
        instance.test(:always)
      end
    end
  rescue LoadError
    puts '>>>>> kitchen gem not loaded, omitting tasks' unless ENV['CI']
  end
end

desc 'Run Test Kitchen integration tests'
task 'integration:vagrant'

desc 'Run all style checks'
task style: ['style:foodcritic', 'style:ruby']

desc 'Run all unit tests'
task unit: ['unit:rspec']

desc 'Run style and unit tests for light CI'
task travis: %w(berkshelf style unit)

desc 'Run all tests including test Kitchen with Vagrant'
task default: ['unit', 'style', 'integration:vagrant']

desc 'Run all tests including test Kitchen with Docker'
task docker: ['unit', 'style', 'integration:docker']

desc 'print cookbook version'
task :version do
  puts cookbook_version
end

desc 'bump minor version'
task :bump do
  versions = cookbook_version.split('.')
  versions[2] = versions[2].to_i + 1
  version = versions.join('.')
  puts "bumping cookbook version to #{version}"

  update_cookbook_version version

  # run_command "git commit metadata.rb -m 'version bumped to #{version}'"
end

VERSION_WITH_NAME_REGEX = /version\s*'\d+\.\d+\.\d+'/
VERSION_REGEX = /\d+\.\d+\.\d+/

def cookbook_version
  # Read in the metadata file
  metadata = IO.read(File.join(File.dirname(__FILE__), 'metadata.rb')).chomp
  version_with_name = VERSION_WITH_NAME_REGEX.match(metadata)[0]
  VERSION_REGEX.match(version_with_name)[0]
end

def update_cookbook_version(version)
  # Read in the metadata file
  metadata = File.read('metadata.rb')
  new_metadata = metadata.gsub(/#{VERSION_WITH_NAME_REGEX}/, "version '#{version}'")
  File.open('metadata.rb', 'w') { |file| file.puts new_metadata }
  puts
end

def run_command(command)
  output = `#{command}`
  raise "#{command} failed with:\n#{output}" unless $CHILD_STATUS.success?
end
