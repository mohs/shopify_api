require 'active_resource'
require 'active_support/core_ext/class/attribute_accessors'
require 'digest/md5'
require 'base64'
require 'active_resource/connection_ext'
require 'shopify_api/limits'

module ShopifyAPI
  include Limits
  
  METAFIELD_ENABLED_CLASSES = %w( Order Product CustomCollection SmartCollection Page Blog Article Variant)
  EVENT_ENABLED_CLASSES = %w( Order Product CustomCollection SmartCollection Page Blog Article )

  module Countable
    def count(options = {})
      Integer(get(:count, options))
    end
  end
end

require 'shopify_api/version'
require 'shopify_api/base'
  
ignore_files = ['cli.rb']
Dir[File.join(File.dirname(__FILE__), 'shopify_api', '**/*.rb')].each do |file|
  require file unless ignore_files.include?(File.basename(file))
end

# Include Metafields module in all enabled classes
ShopifyAPI::METAFIELD_ENABLED_CLASSES.each do |klass|
  "ShopifyAPI::#{klass}".constantize.send(:include, ShopifyAPI::Metafields)
end

# Include Events module in all enabled classes
ShopifyAPI::EVENT_ENABLED_CLASSES.each do |klass|
  "ShopifyAPI::#{klass}".constantize.send(:include, ShopifyAPI::Events)
end