module OpsworksInstanceAgentConfig
  require 'yaml'

  CHEF_CONFIG_YAML='/var/lib/aws/opsworks/client.yml'

  def self.default_cookbooks_path
    YAML.load_file(CHEF_CONFIG_YAML)[:default_cookbooks_path]
  end

  def self.site_cookbooks_path
    YAML.load_file(CHEF_CONFIG_YAML)[:site_cookbooks_path]
  end

  def self.merged_cookbooks_path
    YAML.load_file(CHEF_CONFIG_YAML)[:merged_cookbooks_path]
  end

  def self.berkshelf_cookbooks_path
    YAML.load_file(CHEF_CONFIG_YAML)[:berkshelf_cookbooks_path]
  end

  def self.berkshelf_cache_path
    YAML.load_file(CHEF_CONFIG_YAML)[:berkshelf_cache_path]
  end
end
