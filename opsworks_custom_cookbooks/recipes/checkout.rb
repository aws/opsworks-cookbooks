ensure_scm_package_installed(node[:opsworks_custom_cookbooks][:scm][:type]) unless node[:opsworks_custom_cookbooks][:scm][:type].nil?

prepare_git_checkouts(:user => node[:opsworks_custom_cookbooks][:user],
                      :group => node[:opsworks_custom_cookbooks][:group],
                      :home => node[:opsworks_custom_cookbooks][:home],
                      :ssh_key => node[:opsworks_custom_cookbooks][:scm][:ssh_key]) if node[:opsworks_custom_cookbooks][:scm][:type].to_s == 'git'

prepare_svn_checkouts(:user => node[:opsworks_custom_cookbooks][:user],
                      :group => node[:opsworks_custom_cookbooks][:group],
                      :home => node[:opsworks_custom_cookbooks][:home],
                      :deploy => node[:opsworks_custom_cookbooks]) if node[:opsworks_custom_cookbooks][:scm][:type].to_s == 'svn'

if node[:opsworks_custom_cookbooks][:scm][:type].to_s == 'archive'
  repository = prepare_archive_checkouts(node[:opsworks_custom_cookbooks][:scm])
  node.set[:opsworks_custom_cookbooks][:scm] = {
    :type => 'git',
    :repository => repository
  }
elsif node[:opsworks_custom_cookbooks][:scm][:type].to_s == 's3'
  repository = prepare_s3_checkouts(node[:opsworks_custom_cookbooks][:scm])
  node.set[:opsworks_custom_cookbooks][:scm] = {
   :scm_type => 'git',
   :repository => repository
  }
end

case node[:opsworks_custom_cookbooks][:scm][:type]
when 'git'
  git "Download Custom Cookbooks" do
    enable_submodules node[:opsworks_custom_cookbooks][:enable_submodules]
    depth nil

    user node[:opsworks_custom_cookbooks][:user]
    group node[:opsworks_custom_cookbooks][:group]
    action :checkout
    destination node[:opsworks_custom_cookbooks][:destination]
    repository node[:opsworks_custom_cookbooks][:scm][:repository]
    revision node[:opsworks_custom_cookbooks][:scm][:revision]
    retries 2
    not_if do
      node[:opsworks_custom_cookbooks][:scm][:repository].blank? || ::File.directory?(node[:opsworks_custom_cookbooks][:destination])
    end
  end
when 'svn'
  subversion "Download Custom Cookbooks" do
    svn_username node[:opsworks_custom_cookbooks][:scm][:user]
    svn_password node[:opsworks_custom_cookbooks][:scm][:password]

    user node[:opsworks_custom_cookbooks][:user]
    group node[:opsworks_custom_cookbooks][:group]
    action :checkout
    destination node[:opsworks_custom_cookbooks][:destination]
    repository node[:opsworks_custom_cookbooks][:scm][:repository]
    revision node[:opsworks_custom_cookbooks][:scm][:revision]
    retries 2
    not_if do
      node[:opsworks_custom_cookbooks][:scm][:repository].blank? || ::File.directory?(node[:opsworks_custom_cookbooks][:destination])
    end
  end
else
  raise "unsupported SCM type #{node[:opsworks_custom_cookbooks][:scm][:type].inspect}"
end

ruby_block 'Move single cookbook contents into appropriate subdirectory' do
  block do
    cookbook_name = File.readlines(File.join(node[:opsworks_custom_cookbooks][:destination], 'metadata.rb')).detect{|line| line.match(/^\s*name\s+\S+$/)}[/name\s+['"]([^'"]+)['"]/, 1]
    cookbook_path = File.join(node[:opsworks_custom_cookbooks][:destination], cookbook_name)
    Chef::Log.info "Single cookbook detected, moving into subdirectory '#{cookbook_path}'"
    FileUtils.mkdir(cookbook_path)
    Dir.glob(File.join(node[:opsworks_custom_cookbooks][:destination], '*'), File::FNM_DOTMATCH).each do |cookbook_content|
      FileUtils.mv(cookbook_content, cookbook_path, :force => true)
    end
  end

  only_if do
    ::File.exists?(metadata = File.join(node[:opsworks_custom_cookbooks][:destination], 'metadata.rb')) && File.read(metadata).match(/^\s*name\s+\S+$/)
  end
end

remote_file "/tmp/#{node[:opsworks_custom_cookbooks][:berkshelf_package_file]}" do
  source node[:opsworks_custom_cookbooks][:berkshelf_package_url]

  only_if do
    node[:opsworks_custom_cookbooks][:manage_berkshelf] && ::File.exists?(File.join(node[:opsworks_custom_cookbooks][:destination], 'Berksfile'))
  end
end

package 'berkshelf' do
  source "/tmp/#{node[:opsworks_custom_cookbooks][:berkshelf_package_file]}"
  provider Chef::Provider::Package::Dpkg if ['ubuntu', 'debian'].include?(node[:platform])

  only_if do
    ::File.exists?("/tmp/#{node[:opsworks_custom_cookbooks][:berkshelf_package_file]}")
  end
end

package 'opsworks-berkshelf' do
  action :remove

  not_if do
    node[:opsworks_custom_cookbooks][:manage_berkshelf]
  end
end

execute 'run berks install' do
  command "#{node[:opsworks_custom_cookbooks][:berkshelf_binary]} install --path #{node[:opsworks_custom_cookbooks][:berkshelf_cookbook_path]}"
  cwd node[:opsworks_custom_cookbooks][:destination]

  only_if do
    node[:opsworks_custom_cookbooks][:manage_berkshelf] && ::File.exists?(File.join(node[:opsworks_custom_cookbooks][:destination], 'Berksfile'))
  end
end

directory node[:opsworks_custom_cookbooks][:berkshelf_cookbook_path] do
  action :delete
  recursive true

  not_if do
    node[:opsworks_custom_cookbooks][:manage_berkshelf]
  end
end

execute "ensure correct permissions of custom cookbooks" do
  command "chmod -R go-rwx #{node[:opsworks_custom_cookbooks][:destination]}"
  only_if do
    ::File.exists?(node[:opsworks_custom_cookbooks][:destination])
  end
end
