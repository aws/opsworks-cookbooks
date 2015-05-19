#
# Cookbook Name:: newrelic
# Resource:: deployment
#
# Copyright 2012-2015, Escape Studios
#

actions :notify
default_action :notify

attribute :url, :kind_of => String, :default => 'https://api.newrelic.com/deployments.xml'
attribute :key_type, :kind_of => String, :equal_to => %w(license_key api_key), :default => 'api_key'
attribute :key, :name_attribute => true, :kind_of => String, :default => nil

# @todo take out deprecated api_key logic
attribute :api_key, :kind_of => String, :default => nil

attribute :app_name, :kind_of => String, :name_attribute => true, :default => nil # required when app_id is not set
attribute :app_id, :kind_of => Integer, :default => nil # required when app_name is not set
attribute :description, :kind_of => String, :default => nil # optional
attribute :revision, :kind_of => String, :default => nil # optional
attribute :changelog, :kind_of => String, :default => nil # optional
attribute :user, :kind_of => String, :default => nil # optional

def initialize(*args)
  super
  @action = :notify

  @run_context.include_recipe 'curl'
end
