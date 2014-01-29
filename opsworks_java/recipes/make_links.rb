link ::File.join("//usr/share/tomcat7/lib/ext", "activation.jar") do
  to ::File.join("/usr/share/java/ext", "ccpp.jar")
  action :create
end

link ::File.join("//usr/share/tomcat7/lib/ext", "ccpp.jar") do
  to ::File.join("/usr/share/java/ext", "ccpp.jar")
  action :create
end

link ::File.join("//usr/share/tomcat7/lib/ext", "hsql.jar") do
  to ::File.join("/usr/share/java/ext", "hsql.jar")
  action :create
end
