#
# Create a common interface for the current package manager

module OpsWorks
  # discover installed packages
  module PackageDiscovery
    def installed_packages
      cmdline = case platform_family
      when 'rhel'
        "rpm -qa --queryformat '%{NAME} %{VERSION}\n'"
      when 'debian'
        "dpkg-query -W -f='${Package} ${Version}\n'"
      end

      # mulitline list of installed packages and versions separared by a space
      cmd = Mixlib::ShellOut.new( cmdline )
      cmd.run_command

      # workaround for missing 'error?' method in Mixlib::ShellOut. This method is documented but was not
      # shipped with version 1.3.0
      #
      # http://www.rubydoc.info/github/opscode/mixlib-shellout/Mixlib/ShellOut#error%3F-instance_method
      if cmd.valid_exit_codes.include?(cmd.exitstatus)
        # Hash like: {"package-name" => "version", ...}
        Hash[cmd.stdout.scan(/(\S+)\s(\S+)/)]
      else
        cmd.error!
      end
    end
  end

  # module for retrieving information about installed packages
  module PackageSummary
    class Helper
      def initialize(pmhelper, package)
        raise "Missing reference to a package" unless package.is_a?(String)
        @pmhelper = pmhelper
        @package_info = package_info(package)
      end

      def name
        return nil if @package_info.nil?

        case @pmhelper.platform_family
        when 'rhel'
          @package_info["Name"]
        when 'debian'
          @package_info["Package"]
        end
      end

      def version
        @package_info["Version"] unless @package_info.nil?
      end

      def release
        @package_info["Release"] unless @package_info.nil?
      end

      private
      def package_info(package)
        cmdline = case @pmhelper.platform_family
        when 'rhel'
          "rpm -qi #{package}"
        when 'debian'
          "dpkg --status #{package}"
        end

        cmd = Mixlib::ShellOut.new( cmdline )
        cmd.run_command

        # workaround for missing 'error?' method in Mixlib::ShellOut. This method is documented but was not
        # shipped with version 1.3.0
        #
        # http://www.rubydoc.info/github/opscode/mixlib-shellout/Mixlib/ShellOut#error%3F-instance_method
        if cmd.valid_exit_codes.include?(cmd.exitstatus)
          # rpm and dpkg deliver the package information on a multiline, colon separated string
          Hash[cmd.stdout.split("\n").map{|e| e.split(":", 2).map(&:strip)}]
        else
          nil
        end
      end
    end
  end

  class PackageManagerHelper
    include PackageDiscovery
    include PackageSummary

    attr_reader :platform_family

    def initialize(node)
      @platform_family = node[:platform_family]
    end

    def summary(package)
      PackageSummary::Helper.new(self, package)
    end
  end
end
