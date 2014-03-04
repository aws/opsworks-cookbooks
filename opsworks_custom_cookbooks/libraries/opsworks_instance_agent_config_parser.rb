module OpsworksInstanceAgentConfig
  require 'yaml'

  def self.get_site_cookbooks_dir
    agent_config = YAML.load_file('/etc/aws/opsworks/instance-agent.yml')
    agent_config[:site_cookbooks_dir]
  end
end
