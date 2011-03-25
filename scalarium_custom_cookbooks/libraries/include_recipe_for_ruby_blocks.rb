class Chef::Resource::RubyBlock 
  include Chef::Mixin::LanguageIncludeRecipe
  include Chef::Mixin::LanguageIncludeAttribute
  
  def load_new_cookbooks
    Chef::Log.info("Loading custom cookbooks")
    new_cookbook_collection = Chef::CookbookCollection.new(Chef::CookbookLoader.new)
    node.cookbook_collection = new_cookbook_collection
    
    run_context = self.is_a?(Chef::RunContext) ? self : self.run_context
    run_context.instance_variable_set("@cookbook_collection", new_cookbook_collection)
    run_context.load
    
    node.load_attributes
  end
end