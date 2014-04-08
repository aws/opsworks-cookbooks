module OpsWorks
  module Bershelf
    class << self
      def berkshelf_binary
        "#{Opsworks::InstanceAgent::Environment.embedded_bin_path}/berks"
      end

      def berkshelf_installed?
        ::File.exists?(berkshelf_binary)
      end

      def berksfile_available?
        ::File.exists?(::File.join(Opsworks::InstanceAgent::Environment.site_cookbooks_path, 'Berksfile'))
      end

      def current_version
        if berkshelf_installed?
          # for berkshelf v2.x the expected string to work with is i.e. "Berkshelf (2.0.14)"
          # for berkshelf v3.x the expected string to work with is i.e. "3.0.1"

          OpsWorks::ShellOut.shellout("#{OpsWorks::Bershelf.berkshelf_binary} version | head -n 1").match(/\d+\.\d+\.\d+[^)]*/).to_s
        end
      end
    end
  end
end
