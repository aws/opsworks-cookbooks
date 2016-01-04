node[:deploy].each do |application, deploy|
  # this should be used with figaro gem
  dotenv_path = "#{release_path}/config/application.yml"
  if deploy[:application_type] == 'rails'
    # Dotenv file with sensitive data stored in the OpsWorks' layer.
    deploy[:environment].to_hash.each do |key, value|
      dotenv_contents << "#{key}: #{value}\n"
    end

    file(dotenv_path) do
      mode('0660')
      owner(deploy[:user])
      group(deploy[:group])
      content(dotenv_contents)
      action(:create)
    end

  end
end
