# on micro instances the hard-coded lock_timeout of 10 seconds can be too low
bash 'set lock timeout in Chef\'s yum-dump.py on micro instances' do
  user 'root'
  code <<-EOC
    sed -i '/^lock_timeout/I s/=\s.*$/= #{node[:opsworks_initial_setup][:micro][:yum_dump_lock_timeout]}/' #{node[:opsworks_initial_setup][:micro][:yum_dump_file]}
  EOC
  only_if { node[:platform] == 'amazon' and node[:opsworks][:instance][:instance_type] == 't1.micro' }
end
