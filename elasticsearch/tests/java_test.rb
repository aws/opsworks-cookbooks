describe_recipe 'elasticsearch::default' do

  include MiniTest::Chef::Assertions
  include MiniTest::Chef::Context
  include MiniTest::Chef::Resources

  describe "Java installation" do

    it "installs the correct version and makes it default" do
      if node[:java] and node[:java][:jdk_version] == '7'
        java_version = `java -version 2>&1`
        assert_match /1\.7\.0/, java_version, "Java version #{node.java.jdk_version} does not match: #{java_version}"
      end
    end

  end

end
