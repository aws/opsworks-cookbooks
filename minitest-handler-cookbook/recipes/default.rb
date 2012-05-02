# Hack to install Gem immediately pre Chef 0.10.10 (CHEF-2879)
gem_package "minitest" do
  action :nothing
end.run_action(:install)

gem_package "minitest-chef-handler" do
  action :nothing
end.run_action(:install)

Gem.clear_paths
require "minitest-chef-handler"

# Directory to store cookbook tests
directory "minitest test location" do
  path node[:minitest][:path]
  owner "root"
  group "root"
end

ruby_block "delete tests from old cookbooks" do
  block do
    raise "minitest-handler cookbook could not find directory '#{node[:minitest][:path]}'" unless File.directory?(node[:minitest][:path])
    expired_cookbooks = Dir.entries(node[:minitest][:path]).delete_if { |dir| dir == '.' || dir == '..' || node[:recipes].include?(dir) }
    expired_cookbooks.each do |cookbook|
      Chef::Log.info("Cookbook #{cookbook} no longer in run list, remove minitest tests")
      FileUtils.rm_rf "#{node[:minitest][:path]}/#{cookbook}"
    end
  end
end

# Search through all cookbooks in the run list for tests
node[:recipes].each do |recipe|
  # recipes is actually a list of cookbooks and recipes with :: as a delimiter
  cookbook_name = recipe.split('::').first
  if File.exists?("#{recipe}/files/default/tests/minitest")
	remote_directory "tests-#{cookbook_name}" do
	    source "tests/minitest"
	    cookbook cookbook_name
	    path "#{node[:minitest][:path]}/#{cookbook_name}"
	    purge true
	    ignore_failure true
  	end
  end
end

puts "*********************  #{node[:minitest][:path]}"
puts "*********************  #{node[:minitest].map}"

handler = MiniTest::Chef::Handler.new({
  :path    => "#{node[:minitest][:path]}/**/*_test.rb",
  :verbose => true})

Chef::Log.info("Enabling minitest-chef-handler as a report handler")
Chef::Config.send("report_handlers").delete_if {|v| v.class.inspect.include? 'MiniTest::Chef::Handler'}
Chef::Config.send("report_handlers") << handler
