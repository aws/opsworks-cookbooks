require 'rubygems'
require 'bundler'
Bundler.setup

require 'rake'
require 'foodcritic'
require 'rubocop/rake_task'
require 'emeril/rake_tasks'

task :default => [:foodcritic, :rubocop]

FoodCritic::Rake::LintTask.new do |t|
  t.options = {:fail_tags => ['correctness']}
end

Rubocop::RakeTask.new

begin
  require 'kitchen/rake_tasks'
  Kitchen::RakeTasks.new
rescue LoadError
  puts '>>>>> Kitchen gem not loaded, omitting tasks' unless ENV['CI']
end

Emeril::RakeTasks.new do |t|
  t.config[:category] = "Other"
end
