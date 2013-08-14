#
# Cookbook Name:: redisio
# Provider::install
#
# Copyright 2013, Brian Bianco <brian.bianco@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

action :run do
  @tarball = "#{new_resource.base_name}#{new_resource.version}.#{new_resource.artifact_type}"

  unless ( current_resource.version == new_resource.version || (redis_exists? && new_resource.safe_install) )
    Chef::Log.info("Installing Redis #{new_resource.version} from source")
    download
    unpack
    build
    install
  end
  configure
end

def download
  Chef::Log.info("Downloading redis tarball from #{new_resource.download_url}")
  remote_file "#{new_resource.download_dir}/#{@tarball}" do
    source new_resource.download_url
  end
end

def unpack
  install_dir = "#{new_resource.base_name}#{new_resource.version}"
  case new_resource.artifact_type
    when "tar.gz",".tgz"
      execute %(cd #{new_resource.download_dir} ; mkdir -p '#{install_dir}' ; tar zxf '#{@tarball}' --strip-components=1 -C '#{install_dir}')
    else
      raise Chef::Exceptions::UnsupportedAction, "Current package type #{new_resource.artifact_type} is unsupported"
  end
end

def build
  execute"cd #{new_resource.download_dir}/#{new_resource.base_name}#{new_resource.version} && make clean && make"
end

def install
  execute "cd #{new_resource.download_dir}/#{new_resource.base_name}#{new_resource.version} && make install"
  new_resource.updated_by_last_action(true)
end

def configure
  base_piddir = new_resource.base_piddir
  version_hash = RedisioHelper.version_to_hash(new_resource.version)

  #Setup a configuration file and init script for each configuration provided
  new_resource.servers.each do |current_instance|

    #Retrieve the default settings hash and the current server setups settings hash.
    current_instance_hash = current_instance.to_hash
    current_defaults_hash = new_resource.default_settings.to_hash

    #Merge the configuration defaults with the provided array of configurations provided
    current = current_defaults_hash.merge(current_instance_hash)

    #Merge in the default maxmemory
    node_memory_kb = node["memory"]["total"]
    node_memory_kb.slice! "kB"
    node_memory_kb = node_memory_kb.to_i

    maxmemory = current['maxmemory']
    if current['maxmemory'] && current['maxmemory'].include?("%")
      # Just assume this is sensible like "95%" or "95 %"
      percent_factor = current['maxmemory'].to_f / 100.0
      # Ohai reports memory in KB as it looks in /proc/meminfo
      maxmemory = (node_memory_kb * 1024 * percent_factor / new_resource.servers.length).to_i
    end

    descriptors = current['ulimit'] == 0 ? current['maxclients'] + 32 : current['maxclients']

    recipe_eval do
      server_name = current['name'] || current['port']
      piddir = "#{base_piddir}/#{server_name}"
      aof_file = "#{current['datadir']}/appendonly-#{server_name}.aof"
      rdb_file = "#{current['datadir']}/dump-#{server_name}.rdb"

      #Create the owner of the redis data directory
      user current['user'] do
        comment 'Redis service account'
        supports :manage_home => true
        home current['homedir']
        shell current['shell']
        system current['systemuser']
      end
      #Create the redis configuration directory
      directory current['configdir'] do
        owner 'root'
        group 'root'
        mode '0755'
        recursive true
        action :create
      end
      #Create the instance data directory
      directory current['datadir'] do
        owner current['user']
        group current['group']
        mode '0775'
        recursive true
        action :create
      end
      #Create the pid file directory
      directory piddir do
        owner current['user']
        group current['group']
        mode '0755'
        recursive true
        action :create
      end
      #Create the log directory if syslog is not being used
      directory ::File.dirname("#{current['logfile']}") do
        owner current['user']
        group current['group']
        mode '0755'
        recursive true
        action :create
        only_if { current['syslogenabled'] != 'yes' && current['logfile'] && current['logfile'] != 'stdout' }
      end
      #Create the log file is syslog is not being used
      file current['logfile'] do
        owner current['user']
        group current['group']
        mode '0644'
        backup false
        action :touch
        only_if { current['logfile'] && current['logfile'] != 'stdout' }
      end
      #Set proper permissions on the AOF or RDB files
      file aof_file do
        owner current['user']
        group current['group']
        mode '0644'
        only_if { current['backuptype'] == 'aof' || current['backuptype'] == 'both' }
        only_if { ::File.exists?(aof_file) }
      end
      file rdb_file  do
        owner current['user']
        group current['group']
        mode '0644'
        only_if { current['backuptype'] == 'rdb' || current['backuptype'] == 'both' }
        only_if { ::File.exists?(rdb_file) }
      end
      #Setup the redis users descriptor limits
      if current['ulimit']
        user_ulimit current['user'] do
          filehandle_limit descriptors
        end
      end
      #Lay down the configuration files for the current instance
      template "#{current['configdir']}/#{server_name}.conf" do
        source 'redis.conf.erb'
        cookbook 'redisio'
        owner current['user']
        group current['group']
        mode '0644'
        variables({
          :version                => version_hash,
          :piddir                 => piddir,
          :name                   => server_name,
          :job_control            => current['job_control'],
          :port                   => current['port'],
          :address                => current['address'],
          :databases              => current['databases'],
          :backuptype             => current['backuptype'],
          :datadir                => current['datadir'],
          :unixsocket             => current['unixsocket'],
          :unixsocketperm         => current['unixsocketperm'],
          :timeout                => current['timeout'],
          :loglevel               => current['loglevel'],
          :logfile                => current['logfile'],
          :syslogenabled          => current['syslogenabled'],
          :syslogfacility         => current['syslogfacility'],
          :save                   => current['save'],
          :slaveof                => current['slaveof'],
          :masterauth             => current['masterauth'],
          :slaveservestaledata    => current['slaveservestaledata'],
          :replpingslaveperiod    => current['replpingslaveperiod'],
          :repltimeout            => current['repltimeout'],
          :requirepass            => current['requirepass'],
          :maxclients             => current['maxclients'],
          :maxmemory              => maxmemory,
          :maxmemorypolicy        => current['maxmemorypolicy'],
          :maxmemorysamples       => current['maxmemorysamples'],
          :appendfsync            => current['appendfsync'],
          :noappendfsynconrewrite => current['noappendfsynconrewrite'],
          :aofrewritepercentage   => current['aofrewritepercentage'] ,
          :aofrewriteminsize      => current['aofrewriteminsize'],
          :includes               => current['includes']
        })
      end
      #Setup init.d file
      template "/etc/init.d/redis#{server_name}" do
        source 'redis.init.erb'
        cookbook 'redisio'
        owner 'root'
        group 'root'
        mode '0755'
        variables({
          :name => server_name,
          :job_control => current['job_control'],
          :port => current['port'],
          :address => current['address'],
          :user => current['user'],
          :configdir => current['configdir'],
          :piddir => piddir,
          :requirepass => current['requirepass'],
          :shutdown_save => current['shutdown_save'],
          :platform => node['platform'],
          :unixsocket => current['unixsocket']
          })
        only_if { current['job_control'] == 'initd' }
      end
      template "/etc/init/redis#{server_name}.conf" do
        source 'redis.upstart.conf.erb'
        cookbook 'redisio'
        owner current['user']
        group current['group']
        mode '0644'
        variables({
          :name => server_name,
          :job_control => current['job_control'],
          :port => current['port'],
          :address => current['address'],
          :user => current['user'],
          :group => current['group'],
          :maxclients => current['maxclients'],
          :requirepass => current['requirepass'],
          :shutdown_save => current['shutdown_save'],
          :save => current['save'],
          :configdir => current['configdir'],
          :piddir => piddir,
          :platform => node['platform'],
          :unixsocket => current['unixsocket']
        })
        only_if { current['job_control'] == 'upstart' }
      end
    end
  end # servers each loop
end

def redis_exists?
  exists = Mixlib::ShellOut.new("which redis-server")
  exists.run_command
  exists.exitstatus == 0 ? true : false
end

def version
  if redis_exists?
    redis_version = Mixlib::ShellOut.new("redis-server -v")
    redis_version.run_command
    version = redis_version.stdout[/version (\d*.\d*.\d*)/,1] || redis_version.stdout[/v=(\d*.\d*.\d*)/,1]
    Chef::Log.info("The Redis server version is: #{version}")
    return version.gsub("\n",'')
  end
  nil
end

def load_current_resource
  @current_resource = Chef::Resource::RedisioInstall.new(new_resource.name)
  @current_resource.version(version)
  @current_resource
end
