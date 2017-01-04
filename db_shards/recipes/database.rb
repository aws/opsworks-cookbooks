include_recipe "deploy"

node[:deploy].each do |application, deploy|
  if node['rails']
    node['rails']['db'].each do |type, dbs|
      if type == 'slaves'
        template "#{deploy[:deploy_to]}/shared/config/shards.yml" do
          source 'shards.yml.erb'
          mode "0660"
          group deploy[:group]
          owner deploy[:user]
          variables(dbs: dbs)
        end
      end
    end
  end

end
