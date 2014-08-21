require 'minitest/spec'

describe_recipe 'deploy::nodejs' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  # This ensures that we actually have the monit file in the right place -
  # this bit in the Chef cookbook can fail silently if we throw the
  # file where we don't expect it on a different OS.
  it 'ensures monit is actually monitoring the service' do
    node[:deploy].each do |app, deploy|
      if deploy[:application_type] == 'nodejs'
        assert system("monit status | grep node_web_app_#{app}")
      end
    end
  end

  it 'writes SSL certificate files to disk' do
    node[:deploy].each do |app, deploy|
      if deploy[:application_type] == 'nodejs' && deploy[:ssl_support]
        ssl_certificate = file("#{deploy[:deploy_to]}/shared/config/ssl.crt")
        ssl_certificate.must_exist.with(:owner, deploy[:user]).and(:mode, 0600)
        ssl_certificate.must_include deploy[:ssl_certificate]
      end

      if deploy[:application_type] == 'nodejs' && deploy[:ssl_support]
        ssl_certificate_key = file("#{deploy[:deploy_to]}/shared/config/ssl.key")
        ssl_certificate_key.must_exist.with(:owner, deploy[:user]).and(:mode, 0600)
        ssl_certificate_key.must_include deploy[:ssl_certificate_key]
      end

      if deploy[:application_type] == 'nodejs' && deploy[:ssl_support] && deploy[:ssl_certificate_ca].present?
        ssl_certificate_ca = file("#{deploy[:deploy_to]}/shared/config/ssl.ca")
        ssl_certificate_ca.must_exist.with(:owner, deploy[:user]).and(:mode, 0600)
        ssl_certificate_ca.must_include deploy[:ssl_certificate_ca]
      end
    end
  end

  it 'uses the default ports for http and https' do
    node[:deploy].each do |app, deploy|
      next unless deploy[:application_type] == "nodejs"
      port = deploy[:ssl_support] ? 443 : 80
      monit_config = file(::File.join(node[:monit][:conf_dir], "node_web_app-#{app}.monitrc"))

      monit_config.must_include "PORT=#{port}"

      if deploy[:ssl_support]
        monit_config.must_include "if failed port #{port} type TCPSSL protocol HTTP"
      else
        monit_config.must_include "if failed port #{port} protocol HTTP"
      end
    end
  end
end
