desc 'check literal recipe includes'
task :validate_literal_includes do
  Dir['**/*.rb'].each do |file|
    recipes = File.read(file).scan(/(?:include_recipe\s+(['"])([\w:]+)\1)/).reject {|candidate| candidate.last.include?('#{}')}.map(&:last)
    recipes.each do |recipe|
      recipe_file = recipe.include?('::') ? recipe.sub('::', '/recipes/') + '.rb' : recipe + '/recipes/default.rb'
      unless File.exists?(recipe_file)
        puts "#{file} includes missing recipe #{recipe}"
        exit 1
      end
    end
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

    if found_trouble
      exit 1
    end
  end
end

desc 'check syntax of ruby files'
task :validate_syntax do
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

desc 'run all checks'
task :default => [:validate_literal_includes, :validate_syntax, :validate_attribute_dependencies]
