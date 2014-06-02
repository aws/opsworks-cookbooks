# Remove installed version, if it's not the one that should be installed.
# We only support one user space ruby installation

PACKAGE_BASENAME = "opsworks-ruby"
package_name = case node[:platform_family]
               when "rhel"
                 PACKAGE_BASENAME + [node[:ruby][:major_version], node[:ruby][:minor_version]].join('')
               when "debian"
                 PACKAGE_BASENAME + [node[:ruby][:major_version], node[:ruby][:minor_version]].join('.')
               end

LECAGY_PACKAGES = ["ruby-enterprise"]

pm_helper = OpsWorks::PackageManagerHelper.new(node)
current_package_info = pm_helper.summary(package_name)

if current_package_info.version && current_package_info.version =~ /#{node[:ruby][:full_version]}.#{node[:ruby][:patch_version]}.#{node[:ruby][:pkgrelease]}/
  Chef::Log.info("Userspace Ruby version is up-to-date (#{node[:ruby][:full_version]} patch #{node[:ruby][:patch]} release #{node[:ruby][:pkgrelease]})")
else

  packages_to_remove = pm_helper.installed_packages.select do |pkg, version|
    pkg.include?(PACKAGE_BASENAME) || LECAGY_PACKAGES.include?(pkg)
  end

  packages_to_remove.each do |pkg, version|
    package "Remove outdated package #{pkg}" do
      package_name pkg
      action :remove
    end
  end

  log "downloading" do
    message "Download and install Ruby version #{node[:ruby][:full_version]} patch #{node[:ruby][:patch]} release #{node[:ruby][:pkgrelease]}"
    level :info

    action :nothing
  end

  opsworks_commons_assets_installer "Install user space OpsWorks ruby package" do
    asset package_name
    version node[:ruby][:version]
    release node[:ruby][:pkgrelease]

    notifies :write, "log[downloading]", :immediately
    action :install
  end
end

include_recipe 'opsworks_rubygems'
include_recipe 'opsworks_bundler'
