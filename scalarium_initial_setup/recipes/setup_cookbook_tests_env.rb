# setup environment for running cookbook tests
#
# This recipe uses "minitest-chef-handler" to facilitate cookbook testing.
#
#  minitest-chef-handler project: https://github.com/calavera/minitest-chef-handler

Scalarium::InternalGems.internal_gem_package "minitest-chef-handler", :version => "0.6.1.1"

require "minitest-chef-handler"

Chef::Log.info("Enabling minitest-chef-handler as a report handler")

handler = MiniTest::Chef::Handler.new({
  :verbose => true})

Chef::Config.send("report_handlers").delete_if do |v|
  v.class.to_s.include? MiniTest::Chef::Handler
end

Chef::Config.send("report_handlers") << handler
