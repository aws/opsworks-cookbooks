class Chef::Resource::RubyBlock 
  include Chef::Mixin::LanguageIncludeRecipe
  include Chef::Mixin::LanguageIncludeAttribute
  
  def load_new_cookbooks
    @cookbook_loader = @node.cookbook_loader # needed for include_recipe to work
    Chef::Log.info("Loading custom cookbooks")
    @cookbook_loader.load_cookbooks
    
    Chef::Log.info("Re-Loading all libraries")
    @cookbook_loader.each do |cookbook|
      cookbook.load_libraries
    end
    
    # Chef::Log.info("Re-Loading all providers")
    # @cookbook_loader.each do |cookbook|
    #   cookbook.load_providers
    # end
    # 
    # Chef::Log.info("Re-Loading all resources")
    # @cookbook_loader.each do |cookbook|
    #   cookbook.load_resources
    # end
    
    Chef::Log.info("Re-Loading all attributes")
    @cookbook_loader.each do |cookbook|
      cookbook.load_attributes(@node)
    end
    
    reload_definitions
  end
  
  def reload_definitions
    @definitions = {}
    Chef::Log.info("Re-Loading all definitions")
    @cookbook_loader.each do |cookbook|
      hash = cookbook.load_definitions
      @definitions.merge!(hash)
    end
  end
  
end