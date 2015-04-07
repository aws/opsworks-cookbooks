require 'serverspec'
require 'uri'
require 'net/http'

set :backend, :exec

describe package('nginx') do
  it { should be_installed }
end

describe port(80) do
  it { should be_listening }
end

describe port(443) do
  it { should be_listening }
end

describe "nginx" do
  it "serves geminabox over HTTPS" do
    uri = URI('https://127.0.0.1')
    js = Regexp.escape(%{geminabox})
    Net::HTTP.start(uri.host, uri.port, :use_ssl => true, :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |https|
      result = https.get('/').body
      expect(result).to match(Regexp.new(js))
    end
  end
end
