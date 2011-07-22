ruby_block "ensure only our unicorn version is installed by deinstalling any other version" do
  block do
    ensure_only_gem_version('unicorn', node[:unicorn][:version])
  end
end
