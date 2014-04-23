module Opsworks
  module InstanceAgent
    module Environment
      require 'yaml'

      CHEF_CONFIG_YAML = '/var/lib/aws/opsworks/client.yml'
      INSTANCE_AGENT_CONFIG = '/etc/aws/opsworks/instance-agent.yml'
      INSTANCE_AGENT_EMBEDDED_BIN_PATH = "/opt/aws/opsworks/local/bin"

      class Config
        class << self
          def opsworks_chef_config
            @opsworks_chef_config ||= YAML.load_file(Opsworks::InstanceAgent::Environment::CHEF_CONFIG_YAML)
          end

          def opsworks_instance_agent_config
            @opsworks_instance_agent_config ||= YAML.load_file(Opsworks::InstanceAgent::Environment::INSTANCE_AGENT_CONFIG)
          end
        end
      end

      def self.agent_user
        Config.opsworks_instance_agent_config[:user]
      end

      def self.agent_group
        Config.opsworks_instance_agent_config[:group]
      end

      def self.agent_root_dir
        Config.opsworks_instance_agent_config[:root_dir]
      end

      def self.instance_id
        Config.opsworks_instance_agent_config[:identity]
      end

      def self.default_cookbooks_path
        Config.opsworks_chef_config[:default_cookbooks_path]
      end

      def self.site_cookbooks_path
        Config.opsworks_chef_config[:site_cookbooks_path]
      end

      def self.merged_cookbooks_path
        Config.opsworks_chef_config[:merged_cookbooks_path]
      end

      def self.berkshelf_cookbooks_path
        Config.opsworks_chef_config[:berkshelf_cookbooks_path]
      end

      def self.berkshelf_cache_path
        Config.opsworks_chef_config[:berkshelf_cache_path]
      end

      def self.file_cache_path
        Config.opsworks_chef_config[:file_cache_path]
      end

      def self.embedded_bin_path
        INSTANCE_AGENT_EMBEDDED_BIN_PATH
      end

      def self.ruby_binary
        "#{embedded_bin_path}/ruby"
      end

      def self.gem_binary
        "#{embedded_bin_path}/gem"
      end
    end
  end
end
