if node[:platform] == 'amazon'
  # the hard-coded lock_timeout of 10 seconds can be too low
  bash 'set lock timeout in Chef\'s yum-dump.py' do
    user 'root'
    code <<-EOC
      sed -i 's/lock_timeout\s=\s.*$/lock_timeout = #{node[:opsworks_initial_setup][:yum_dump_lock_timeout]}/' #{node[:opsworks_agent][:current_dir]}/vendor/bundle/ruby/1.8/gems/chef-0.9.15.5/lib/chef/provider/package/yum-dump.py
    EOC
  end
end
