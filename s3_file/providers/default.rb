require 'digest/md5'
require 'json'

use_inline_resources

action :create do
  @run_context.include_recipe 's3_file::dependencies'
  client = S3FileLib::client
  download = true

  # handle key specified without leading slash
  remote_path = ::File.join('', new_resource.remote_path)

  # we need credentials to be mutable
  aws_access_key_id = new_resource.aws_access_key_id
  aws_secret_access_key = new_resource.aws_secret_access_key
  token = new_resource.token
  decryption_key = new_resource.decryption_key

  # if credentials not set, try instance profile
  if aws_access_key_id.nil? && aws_secret_access_key.nil? && token.nil?
    instance_profile_base_url = 'http://169.254.169.254/latest/meta-data/iam/security-credentials/'
    begin
      instance_profiles = client.get(instance_profile_base_url)
    rescue client::ResourceNotFound, Errno::ETIMEDOUT # we can either 404 on an EC2 instance, or timeout on non-EC2
      raise ArgumentError.new 'No credentials provided and no instance profile on this machine.'
    end
    instance_profile_name = instance_profiles.split.first
    instance_profile = JSON.load(client.get(instance_profile_base_url + instance_profile_name))

    aws_access_key_id = instance_profile['AccessKeyId']
    aws_secret_access_key = instance_profile['SecretAccessKey']
    token = instance_profile['Token']
  end

  if ::File.exists?(new_resource.path)
    if decryption_key.nil?
      if new_resource.decrypted_file_checksum.nil?
        s3_md5 = S3FileLib::get_md5_from_s3(new_resource.bucket, new_resource.s3_url, remote_path, aws_access_key_id, aws_secret_access_key, token)

        if S3FileLib::verify_md5_checksum(s3_md5, new_resource.path)
          Chef::Log.debug 'Skipping download, md5sum of local file matches file in S3.'
          download = false
        end
      #we have a decryption key so we must switch to the sha256 checksum
      else
        if S3FileLib::verify_sha256_checksum(new_resource.decrypted_file_checksum, new_resource.path)
          Chef::Log.debug 'Skipping download, sha256 of local file matches recipe.'
          download = false
        end
      end
      # since our resource is a decrypted file, we must use the
      # checksum provided by the resource to compare to the local file
    else
      unless new_resource.decrypted_file_checksum.nil?
        if S3FileLib::verify_sha256_checksum(new_resource.decrypted_file_checksum, new_resource.path)
          Chef::Log.debug 'Skipping download, sha256 of local file matches recipe.'
          download = false
        end
      end
    end
  end

  if download
    response = S3FileLib::get_from_s3(new_resource.bucket, new_resource.s3_url, remote_path, aws_access_key_id, aws_secret_access_key, token)

    # not simply using the file resource here because we would have to buffer
    # whole file into memory in order to set content this solves
    # https://github.com/adamsb6/s3_file/issues/15
    unless decryption_key.nil?
      begin
        decrypted_file = S3FileLib::aes256_decrypt(decryption_key,response.file.path)
      rescue OpenSSL::Cipher::CipherError => e

        Chef::Log.error("Error decrypting #{name}, is decryption key correct?")
        Chef::Log.error("Error message: #{e.message}")

        raise e
      end

      ::FileUtils.mv(decrypted_file.path, new_resource.path)
    else
      ::FileUtils.mv(response.file.path, new_resource.path)
    end
  end

  f = file new_resource.path do
    action :create
    owner new_resource.owner || ENV['user']
    group new_resource.group || ENV['user']
    mode new_resource.mode || '0644'
  end

  new_resource.updated_by_last_action(download || f.updated_by_last_action?)
end
