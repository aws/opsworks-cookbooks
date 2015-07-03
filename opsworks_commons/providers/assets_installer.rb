require 'uri'

# install it
action :install do
  local_asset do |local_asset_path|
    package @new_resource.asset do
      package_name new_resource.asset
      source local_asset_path

      ignore_failure new_resource.ignore_failure

      if platform_family?("debian")
        provider Chef::Provider::Package::Dpkg
      elsif platform_family?("rhel")
        provider Chef::Provider::Package::Yum
        options "--disablerepo=*"
      end

      # to run during chef compile phase and thus keep the execution
      # order in the yield call on the local_asset method
      action :nothing
    end.run_action(:install)
  end
end

private

def arch
  @arch ||= if platform_family?("debian")
    node[:kernel][:machine] == 'x86_64' ? 'amd64' : 'i386'
  elsif platform_family?("rhel")
    node[:kernel][:machine] == 'x86_64' ? 'x86_64' : 'i686'
  else
    node[:kernel][:machine]
  end
end

def asset_name
  name = @new_resource.asset
  version = @new_resource.version
  release = @new_resource.release

  # this reflects OpsWorks package naming schema
  @asset_name ||= if platform_family?("debian")
    "#{name}_#{version}-#{release}_#{arch}.deb"
  elsif platform_family?("rhel")
    "#{name}-#{version}-#{release}.#{arch}.rpm"
  end
end

def asset_url
  _platform_version = node[:platform_version]
  if %w(redhat centos).include?(node["platform"]) && Chef::VersionConstraint.new("~> 6.0").include?(node["platform_version"])
    _platform_version = "6"
  elsif rhel7?
    _platform_version = "7"
  end

  @asset_url ||= URI.parse("#{node[:opsworks_commons][:assets_url]}/packages/#{node[:platform]}/#{_platform_version}/#{asset_name}")
end

# download assets using the downloader.sh
def local_asset
  downloader_script = ::File.join(Opsworks::InstanceAgent::Environment.default_cookbooks_path, '../bin/downloader.sh')
  download_basedir = Opsworks::InstanceAgent::Environment.file_cache_path.empty? ? '/tmp/opsworks_assets' : "#{Opsworks::InstanceAgent::Environment.file_cache_path}/opsworks_assets"

  asset_basedir = "#{download_basedir}/#{@new_resource.asset}"
  ::FileUtils.mkdir_p asset_basedir

  local_asset_path = `#{downloader_script} -r #{@new_resource.max_fetch_retries} -u #{asset_url} -d "#{asset_basedir}"`.chomp

  if $?.success? &&
     ::File.file?(local_asset_path) &&
     ::File.fnmatch("#{asset_basedir}.*", ::File.dirname(local_asset_path))

    yield(local_asset_path)

    # remove all downloaded file for this asset, also failed attemps.
    ::FileUtils.rm_rf(Dir["#{asset_basedir}.*"], :verbose => true) rescue Chef::Log.error "Couldn't cleanup downloaded assets for #{@new_resource.name}."
  elsif @new_resource.ignore_failure
    Chef::Log.error "Failed to download asset #{asset_name} for #{@new_resource.name} with url #{asset_url}."
  elsif !@new_resource.ignore_failure
    raise Chef::Exceptions::ResourceNotFound, "Failed to download asset #{@new_resource.asset} for #{@new_resource.name} with url #{asset_url}."
  end
end
