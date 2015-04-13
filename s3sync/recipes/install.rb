node[:deploy].each do |app_name, deploy|

  package 's3cmd' do
    action :install
  end

  directory "/etc/s3sync/" do
    owner 'root'
    mode 0755
  end 
  
  cookbook_file "s3cfg" do
    path "/etc/s3sync/s3cfg"
    owner 'root'
  end


end
