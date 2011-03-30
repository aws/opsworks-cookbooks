desc 'check literal recipe includes'
task :validate_literal_includes do
  Dir['**/*.rb'].each do |file|
    recipes = File.read(file).scan(/(?:include_recipe\s+(['"])(\w+)\1)/).reject {|candidate| candidate.last.include?('#{}')}.map(&:last)
    recipes.each do |recipe|
      recipe_file = recipe.include?('::') ? recipe.sub('::', '/recipes/') + '.rb' : recipe + '/recipes/default.rb'
      unless File.exists?(recipe_file)
        puts "#{file} includes missing recipe #{recipe}"
        exit 1
      end
    end
  end
end

desc 'check syntax of ruby files'
task :validate_syntax do
  Dir['**/*.rb'].each do |file|
    `ruby -c #{file}`
    if $?.exitstatus != 0
      puts "syntax error in #{file}"
      exit 1
    end
  end
end

desc 'run all checks'
task :default => [:validate_literal_includes, :validate_syntax]
