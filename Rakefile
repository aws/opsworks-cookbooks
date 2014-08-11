#/usr/bin/env rake

require 'fileutils'

Encoding.default_external = Encoding::UTF_8 unless RUBY_VERSION.start_with? "1.8"
Encoding.default_internal = Encoding::UTF_8 unless RUBY_VERSION.start_with? "1.8"

desc 'check literal recipe includes'
task :validate_literal_includes do
  puts "Check literal recipe includes"
  found_issue = false
  Dir['**/*.rb'].each do |file|
    begin
      recipes = File.read(file).scan(/(?:include_recipe\s+(['"])([\w:]+)\1)/).reject {|candidate| candidate.last.include?('#{}')}.map(&:last)
      recipes.each do |recipe|
        recipe_file = recipe.include?('::') ? recipe.sub('::', '/recipes/') + '.rb' : recipe + '/recipes/default.rb'
        unless File.exists?(recipe_file)
          puts "#{file} includes missing recipe #{recipe}"
          found_issue = true
        end
      end
    rescue => e
      warn "Exception when checking #{file}."
      raise e
    end
    exit 1 if found_issue
  end
end

KNOWN_COOKBOOK_ATTRIBUTES = {
  'opsworks_agent' => 'opsworks_initial_setup',
  'passenger' => 'passenger_apache2',
  'ganglia' => 'opsworks_ganglia',
  'sudoers' => 'ssh_users',
  'opsworks' => :any,
  'platform' => :any,
  'platform_family' => :any,
  'platform_version' => :any,
  'apache' => 'apache2',
  'kernel' => 'apache2'
}

desc 'check declared attribute dependencies'
task :validate_attribute_dependencies do
  puts "Validate attribute dependencies"
  Dir['**/*.rb'].each do |file|
    next unless file.match(/\/attributes\//)
    used_cookbook_attributes = []
    found_trouble = false

    cookbook_name = file.match(/(\w+)\//)[1]
    loaded_cookbook_attributes = [cookbook_name]

    File.read(file).each_line do |line|
      # uses other cookbooks attributes
      if line.match(/node\[\:(\w+)\]/) && $1 != cookbook_name
        used_cookbook_attributes << $1
      end

      # loads/includes attributes
      if line.match(/include_attribute [\'\"](\w+)(::\w+)?[\'\"]/)
        loaded_cookbook_attributes << $1
      end
    end

    used_cookbook_attributes.uniq!
    loaded_cookbook_attributes.uniq!
    used_cookbook_attributes_without_include = used_cookbook_attributes - loaded_cookbook_attributes
    used_cookbook_attributes_without_include.delete_if{|cookbook_attribute| KNOWN_COOKBOOK_ATTRIBUTES[cookbook_attribute] == :any || loaded_cookbook_attributes.include?(KNOWN_COOKBOOK_ATTRIBUTES[cookbook_attribute]) }

    if used_cookbook_attributes_without_include.size > 0
      puts "#{file} used attributes from #{used_cookbook_attributes.inspect} but does only loads from #{loaded_cookbook_attributes.inspect}"
      found_trouble = true
    end

    exit 1 if found_trouble
  end
end

desc 'check syntax of ruby files'
task :validate_syntax do
  puts "Check syntax of Ruby files"
  found_trouble = false
  Dir['**/*.rb'].each do |file|
    output = `ruby -c #{file}`
    if $?.exitstatus != 0
      puts output
      found_trouble = true
    end
  end
  exit 1 if found_trouble
end

desc 'check cookbooks with Foodcritic'
task :validate_best_practises do
  if RUBY_VERSION.start_with? "1.8"
    warn "Foodcritic requires Ruby 1.9+. You run 1.8. Skipping..."
  else
    puts "Check Cookbooks with Foodcritic"
    system "foodcritic -t correctness -f correctness ."
    exit 1 unless $?.success?
  end
end

desc 'Check that all cookbooks include a customize.rb'
task :validate_customize do
  errors = []
  Dir.glob("*/attributes/*.rb").map do |file|
    next if File.basename(file) == "customize.rb"

    found = false
    IO.readlines(file).each do |line|
      # loads/includes attributes
      if line.match(/include_attribute [\'\"](\w+)::(\w+)?[\'\"]/)
        if $1 == file.split('/').first && $2 == "customize"
          found = true
        end
      end
    end

    errors << file unless found
    puts "OK: #{file}" if found
  end

  if errors.any?
    errors.each { |e| warn "Does not include customize.rb: #{e}" }
    exit 1
  end
end

desc 'run all checks'
task :default => [:validate_syntax, :validate_literal_includes, :validate_best_practises, :validate_attribute_dependencies, :validate_customize]
