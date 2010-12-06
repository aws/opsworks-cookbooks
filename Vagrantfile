class ChefSolo0910Provisioner < Vagrant::Provisioners::ChefSolo

  def provision!
    env.ui.info "Installing Chef 0.9.10"
    vm.ssh.execute do |ssh|
      ssh.exec!("sudo gem install chef -v '= 0.9.10' --no-ri --no-rdoc")
    end
    super
  end
end

Vagrant::Config.run do |config|
  config.vm.box = "lucid32"
  config.vm.network "10.10.10.2"
  config.vm.provisioner = ChefSolo0910Provisioner
  config.chef.cookbooks_path = "."
  chef_json = JSON.parse(File.read(File.dirname(__FILE__) + "/scalarium.json"))
  recipes = chef_json.delete('recipes')
  config.chef.json = chef_json
  config.chef.add_recipe("vagrant")
  recipes.each {|recipe| config.chef.add_recipe(recipe)}
end
