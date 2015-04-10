Chef::Log.debug "Installing and configuring minitest and minitest-chef-handler"

chef_gem "minitest"
chef_gem "minitest-chef-handler"

require "minitest-chef-handler"

test_pattern = './**/*elasticsearch*/tests/**/*_test.rb'
test_files   = Dir[test_pattern].entries.inject([]) do |result,item|
  result << item unless result.any? { |i| i.include? item.split('/').last }
  result
end

Chef::Log.debug "Will run these tests: #{test_files.inspect}"

handler = MiniTest::Chef::Handler.new({
  :path    => test_files,
  :verbose => true
})

Chef::Log.info("Enabling minitest-chef-handler as a report handler")
Chef::Config.send("report_handlers") << handler
