action :berks_install do
  directory Opsworks::InstanceAgent::Environment.berkshelf_cookbooks_path do
    action :delete
    recursive true

    only_if do
      node['opsworks_berkshelf']['version'].to_i >= 3
    end
  end

  ruby_block 'Install the cookbooks specified in the Berksfile and their dependencies' do
    block do
      Chef::Log.info OpsWorks::ShellOut.shellout(
        berks_install_command,
        :cwd => ::File.dirname(OpsWorks::Berkshelf.berksfile),
        :environment  => {
          "BERKSHELF_PATH" => Opsworks::InstanceAgent::Environment.berkshelf_cache_path,
          "LC_ALL" => "en_US.UTF-8"
        }
      )
    end

    only_if do
      OpsWorks::Berkshelf.berkshelf_installed? && OpsWorks::Berkshelf.berksfile_available?
    end
  end
end

def berks_install_command
  options = if node['opsworks_berkshelf']['version'].to_i >= 3
    "vendor #{Opsworks::InstanceAgent::Environment.berkshelf_cookbooks_path}"
  else
    "install --path #{Opsworks::InstanceAgent::Environment.berkshelf_cookbooks_path}"
  end

  options += ' --debug' if node['opsworks_berkshelf']['debug']

  "#{OpsWorks::Berkshelf.berkshelf_binary} #{options}"
end
