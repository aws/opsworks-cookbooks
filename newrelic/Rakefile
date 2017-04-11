require 'rspec/core/rake_task'

# syntax/lint checks: RuboCop & Foodcritic
namespace :lint do
  require 'rubocop/rake_task'
  require 'foodcritic'

  desc 'Run Ruby syntax/lint checks'
  RuboCop::RakeTask.new(:ruby)

  desc 'Run Chef syntax/lint checks'
  FoodCritic::Rake::LintTask.new(:chef) do |task|
    task.options = {
      :fail_tags => ['any']
    }
  end
end

desc 'Run all syntax/lint checks'
task :lint => ['lint:ruby', 'lint:chef']

# unit testing: ChefSpec
desc 'Run RSpec and ChefSpec unit tests'
RSpec::Core::RakeTask.new(:unit)

# integration testing: Test Kitchen
namespace :integration do
  require 'kitchen'

  desc 'Run Test Kitchen integration tests with Vagrant'
  task :vagrant do
    Kitchen.logger = Kitchen.default_file_logger
    Kitchen::Config.new.instances.each do |instance|
      instance.test(:always)
    end
  end
end

desc 'Run all integration tests'
task :integration => ['integration:vagrant']

# Travic CI
desc 'Run tests on Travis CI'
task :travis => [:lint, :unit]

# the default rake task should just run it all
task :default => [:lint, :unit, :integration]
