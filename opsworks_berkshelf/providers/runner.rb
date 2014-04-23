action :berks_install do
  execute 'Install the cookbooks specified in the Berksfile and their dependencies' do
    command berks_install_command
    cwd Opsworks::InstanceAgent::Environment.site_cookbooks_path
    environment ({
      "BERKSHELF_PATH" => Opsworks::InstanceAgent::Environment.berkshelf_cache_path
    })

    only_if do
      OpsWorks::Bershelf.berkshelf_installed? && OpsWorks::Bershelf.berksfile_available?
    end
  end
end

def berks_install_command
  options = if node['opsworks_berkshelf']['version'].to_i >= 3
    "vendor #{Opsworks::InstanceAgent::Environment.berkshelf_cookbooks_path}"
  else
    "install --path #{Opsworks::InstanceAgent::Environment.berkshelf_cookbooks_path}"
  end

  "#{OpsWorks::Bershelf.berkshelf_binary} #{options}"
end
