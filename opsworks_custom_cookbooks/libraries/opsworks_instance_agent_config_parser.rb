module OpsworksInstanceAgentConfig
  require 'yaml'

  def self.site_cookbooks_dir
    YAML.load_file('/etc/aws/opsworks/instance-agent.yml')[:site_cookbooks_dir]
  end

  def self.berkshelf_cookbooks_dir
    YAML.load_file('/etc/aws/opsworks/instance-agent.yml')[:berkshelf_cookbooks_dir]
  end
end
