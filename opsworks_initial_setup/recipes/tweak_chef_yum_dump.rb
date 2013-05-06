if node[:platform] == 'amazon'
  # on micro instances the hard-coded lock_timeout of 10 seconds can be too low
  bash 'set lock timeout in Chef\'s yum-dump.py on micro instances' do
    user 'root'
    code <<-EOC
      sed -i 's/lock_timeout\s=\s.*$/lock_timeout = #{node[:opsworks_initial_setup][:micro][:yum_dump_lock_timeout]}/' #{node[:opsworks_agent][:current_dir]}/vendor/bundle/ruby/1.8/gems/chef-0.9.15.5/lib/chef/provider/package/yum-dump.py
    EOC
    only_if { node[:opsworks][:instance][:instance_type] == 't1.micro' }
  end
end
