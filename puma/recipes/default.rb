ruby_block "ensure only our puma version is installed by deinstalling any other version" do
  block do
    ensure_only_gem_version('puma', node[:puma][:version])
  end
end
