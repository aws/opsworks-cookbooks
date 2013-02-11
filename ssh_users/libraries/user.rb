module OpsWorks
  module User
    def load_existing_ssh_users
      return {} unless node[:opsworks_gid]

      existing_ssh_users = {}
      (node[:passwd] || node[:etc][:passwd]).each do |username, entry|
        if entry[:gid] == node[:opsworks_gid]
          existing_ssh_users[entry[:uid].to_s] = username
        end
      end
      existing_ssh_users
    end

    def load_existing_users
      existing_users = {}
      (node[:passwd] || node[:etc][:passwd]).each do |username, entry|
        existing_users[entry[:uid].to_s] = username
      end
      existing_users
    end

    def setup_user(params)
      existing_users = load_existing_users
      if existing_users.has_key?(params[:uid])
        Chef::Log.info("UID #{params[:uid]} is taken, not setting up user #{params[:name]}")
      elsif existing_users.has_value?(params[:name])
        Chef::Log.info("Username #{params[:name]} is taken, not setting up user #{params[:name]}")
      else
        Chef::Log.info("setting up user #{params[:name]}")
        user params[:name] do
          action :create
          comment "OpsWorks user #{params[:name]}"
          uid params[:uid]
          gid 'opsworks'
          home "/home/#{params[:name]}"
          supports :manage_home => true
          shell '/bin/bash'
        end

        directory "/home/#{params[:name]}/.ssh" do
          owner params[:name]
          group 'opsworks'
          mode 0700
        end

        set_public_key(params)
      end
    end

    def set_public_key(params)
      Chef::Log.info("setting public key for user #{params[:name]}")
      template "/home/#{params[:name]}/.ssh/authorized_keys" do
        cookbook 'ssh_users'
        source 'authorized_keys.erb'
        owner params[:name]
        group 'opsworks'
        variables(:public_key => params[:public_key])
        only_if do
          File.exists?("/home/#{params[:name]}/.ssh")
        end
      end
    end

    def kill_user_processes(name)
      Chef::Log.info("Killing all processes of user #{name}")
      execute "kill all processes of user #{name}" do
        command "pkill -u #{name}; true"
      end
    end

    def teardown_user(name)
      Chef::Log.info("tearing down user #{name}")
      kill_user_processes(name)

      user name do
        action :remove
        supports :manage_home => true
      end
    end

    def rename_user(old_name, new_name)
      kill_user_processes(old_name)

      Chef::Log.info("renaming user #{old_name} to #{new_name}")
      execute "rename user from #{old_name} to #{new_name}" do
        command "usermod -l #{new_name} -d /home/#{new_name} -m #{old_name}"
      end
    end

    def next_free_uid(starting_from = 4000)
      candidate = starting_from
      existing_uids = []
      (node[:passwd] || node[:etc][:passwd]).each do |username, entry|
        existing_uids << entry[:uid]
      end
      while existing_uids.include?(candidate) do
        candidate += 1
      end
      candidate
    end
  end
end

class Chef::Recipe
  include OpsWorks::User
end
class Chef::Resource::User
  include OpsWorks::User
end
