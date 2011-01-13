module Scalarium
  module User
    def load_existing_ssh_users
      return {} unless node[:scalarium_gid]

      existing_ssh_users = {}
      node[:passwd].each do |username, entry|
        if entry[:gid] == node[:scalarium_gid]
          existing_ssh_users[entry[:uid].to_s] = username
        end
      end
      existing_ssh_users
    end

    def setup_user(params)
      Chef::Log.info("setting up user #{params[:name]}")
      user params[:name] do
        action :create
        comment "Scalarium user #{params[:name]}"
        uid params[:uid]
        gid 'scalarium'
        home "/home/#{params[:name]}"
        supports :manage_home => true
        shell '/bin/zsh'
      end

      directory "/home/#{params[:name]}/.ssh" do
        owner params[:name]
        group 'scalarium'
        mode 0700
      end
    end

    def set_public_key(params)
      Chef::Log.info("setting public key for user #{params[:name]}")
      template "/home/#{params[:name]}/.ssh/authorized_keys" do
        cookbook 'ssh_users'
        source 'authorized_keys.erb'
        owner params[:name]
        group 'scalarium'
        variables(:public_key => params[:public_key])
      end
    end

    def teardown_user(name)
      Chef::Log.info("tearing down user #{name}")
      execute "kill all processes of user #{name}" do
        command "pkill -u #{name}; true"
      end

      user name do
        action :remove
        supports :manage_home => true
      end
    end

    def rename_user(old_name, new_name)
      Chef::Log.info("renaming user #{old_name} to #{new_name}")
      execute "rename user from #{old_name} to #{new_name}" do
        command "usermod -l #{new_name} -d /home/#{new_name} -m #{old_name}"
      end
    end
  end
end

class Chef::Recipe
  include Scalarium::User
end
