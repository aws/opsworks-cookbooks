def up_to_date?
  OpsWorks::Berkshelf.berkshelf_installed? && node['opsworks_berkshelf']['version'] == OpsWorks::Berkshelf.current_version
end

unless up_to_date?
  include_recipe "opsworks_berkshelf::purge"

  log "downloading" do
    message "Trying to download and install pre-built package for berkshelf version #{node['opsworks_berkshelf']['version']}"
    level :info

    action :nothing
  end

  Chef::Log.info "Install berkself dependency: git"
  ensure_scm_package_installed("git")

  opsworks_commons_assets_installer "Try to install berkshelf prebuilt package" do
    asset "opsworks-berkshelf"
    version node['opsworks_berkshelf']['version']
    release node['opsworks_berkshelf']['pkg_release']

    ignore_failure true
    notifies :write, "log[downloading]", :immediately
    action :install

    only_if do
      node['opsworks_berkshelf']['prebuilt_versions'].include?(node['opsworks_berkshelf']['version'])
    end
  end

  log "installing gem" do
    message "No pre-built package found for berkshelf version #{node['opsworks_berkshelf']['version']}, trying to install from rubygems.org"
    level :info

    action :nothing
  end

  gem_package 'berkshelf' do
    gem_binary Opsworks::InstanceAgent::Environment.gem_binary
    version node['opsworks_berkshelf']['version']
    options("--bindir #{Opsworks::InstanceAgent::Environment.embedded_bin_path} --no-document #{node['opsworks_berkshelf']['rubygems_options']}")
    ignore_failure false

    notifies :write, "log[installing gem]", :immediately

    action :install
    not_if do
      OpsWorks::Berkshelf.berkshelf_installed?
    end
  end
end

opsworks_berkshelf_runner "Install berkshelf cookbooks"
