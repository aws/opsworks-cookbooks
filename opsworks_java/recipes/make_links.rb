link ::File.join("/usr/share/java/ext", "ccpp.jar") do
  to ::File.join("/usr/share/tomcat7/lib/ext", "ccpp.jar")
  action :create
end
