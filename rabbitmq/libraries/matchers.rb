if defined?(ChefSpec)
  def add_rabbitmq_user(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:rabbitmq_user, :add, resource_name)
  end

  def delete_rabbitmq_user(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:rabbitmq_user, :delete, resource_name)
  end

  def set_permissions_rabbitmq_user(resource_name) # rubocop:disable AccessorMethodName
    ChefSpec::Matchers::ResourceMatcher.new(:rabbitmq_user, :set_permissions, resource_name)
  end

  def clear_permissions_rabbitmq_user(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:rabbitmq_user, :clear_permissions, resource_name)
  end

  def set_tags_rabbitmq_user(resource_name) # rubocop:disable AccessorMethodName
    ChefSpec::Matchers::ResourceMatcher.new(:rabbitmq_user, :set_tags, resource_name)
  end

  def clear_tags_rabbitmq_user(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:rabbitmq_user, :clear_tags, resource_name)
  end

  def change_password_rabbitmq_user(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:rabbitmq_user, :change_password, resource_name)
  end

  def add_rabbitmq_vhost(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:rabbitmq_vhost, :add, resource_name)
  end

  def delete_rabbitmq_vhost(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:rabbitmq_vhost, :delete, resource_name)
  end

  def set_rabbitmq_policy(resource_name) # rubocop:disable AccessorMethodName
    ChefSpec::Matchers::ResourceMatcher.new(:rabbitmq_policy, :set, resource_name)
  end

  def clear_rabbitmq_policy(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:rabbitmq_policy, :clear, resource_name)
  end

  def list_rabbitmq_policy(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:rabbitmq_policy, :list, resource_name)
  end

  def enable_rabbitmq_plugin(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:rabbitmq_plugin, :enable, resource_name)
  end

  def disable_rabbitmq_plugin(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:rabbitmq_plugin, :disable, resource_name)
  end
end
