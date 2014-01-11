include_attribute 'java'

default[:aws][:elb][:load_balancer_name] = "set_me_in_opsworks_elb_databag"
default[:aws][:elb][:cli_download_filename] = "ElasticLoadBalancing.zip"
default[:aws][:elb][:cli_download_url] = "http://ec2-downloads.s3.amazonaws.com/#{node['aws']['elb']['cli_download_filename']}"
default[:aws][:elb][:cli_install_path] = "/usr/local/aws"
default[:aws][:elb][:cli_version] = "1.0.17.0"
default[:aws][:elb][:java_home] = ENV["JAVA_HOME"] || "/usr" || node['java']['java_home']