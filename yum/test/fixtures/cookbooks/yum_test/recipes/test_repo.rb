case node['platform']
when 'fedora'
  yum_repository 'rpmfusion' do
    mirrorlist 'http://mirrors.rpmfusion.org/mirrorlist?repo=free-fedora-$releasever&arch=$basearch'
    enabled true
    options(
       'metadata_expire' => '7d'
    )
  end
end
