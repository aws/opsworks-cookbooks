#!/usr/bin/env rake

# Don't output shell commands for fileutils
Rake::FileUtilsExt.verbose(false)

# Helpers
def sandbox_path
  File.join(File.dirname(__FILE__), %W(tmp cookbooks #{cookbook_name}))
end

def cookbook_name
  File.basename(File.dirname(__FILE__))
end

# test task
desc 'Run the default tests'
task :test =>  ['prepare_sandbox', 'knife', 'foodcritic', 'spec']

# default task (test)
task :default => :test

# knife test
desc 'Runs knife cookbook test'
task :knife do
  Rake::Task[:prepare_sandbox].invoke

  sh "bundle exec knife cookbook test #{cookbook_name} -o #{sandbox_path}/../"
end

# foodcritic
desc 'Runs foodcritic linter'
task :foodcritic do
  Rake::Task[:prepare_sandbox].invoke

  if Gem::Version.new("1.9.2") <= Gem::Version.new(RUBY_VERSION.dup)
    if sh "foodcritic -f any #{sandbox_path}"
      puts 'foodcritic tests passed!'
    end
  else
    puts "WARN: foodcritic run is skipped as Ruby #{RUBY_VERSION} is < 1.9.2."
  end
end

# sandbox helper
task :prepare_sandbox do
  files = %w{*.md *.rb attributes definitions files providers recipes resources spec templates test}

  rm_rf sandbox_path
  mkdir_p sandbox_path
  cp_r Dir.glob("{#{files.join(',')}}"), sandbox_path
end

# RSpec - this needs to be last!
require 'rspec/core/rake_task'
desc 'Run specs'
RSpec::Core::RakeTask.new do |t|
  Rake::Task[:prepare_sandbox].invoke
  t.pattern = File.join(sandbox_path, 'spec/**/*_spec.rb')
end
