require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:unit) do |t|
  t.rspec_opts = [].tap do |a|
    a.push('--color')
    a.push('--format documentation')
  end.join(' ')
end

desc 'Run all tests'
task :test => [:unit]

namespace :travis do
  desc 'Run tests on TravisCI'
  task ci: 'test'
end

task :default => [:test]
