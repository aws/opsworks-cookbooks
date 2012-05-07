# Enable cookbooks tests

Bundler.setup
`bundle install --without development`

require "minitest-chef-handler"

handler = MiniTest::Chef::Handler.new({
  :verbose => true})

Chef::Log.info("Enabling minitest-chef-handler as a report handler")
Chef::Config.send("report_handlers").delete_if {|v| v.class.inspect.include? 'MiniTest::Chef::Handler'}
Chef::Config.send("report_handlers") << handler
