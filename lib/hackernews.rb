require 'hackernews/version'
require 'active_model'
require 'active_support'
require 'active_support/core_ext/array/wrap'
require 'active_support/core_ext/hash'
require 'active_support/core_ext/enumerable'
require 'active_support/dependencies/autoload'
require 'excon'
require 'nokogiri'
require 'json'

module Hackernews
  class Error < StandardError
    class ExconError < Error; end
    class NotFound < Error; end
    class BadRequest < Error; end
  end

  autoload :API, 'hackernews/api'
  autoload :Client, 'hackernews/client'
  autoload :Scraper, 'hackernews/scraper'

  module Entities
    class Base
      include ActiveModel::Model
      include ActiveModel::Serializers::JSON

      def initialize(attributes = {})
        if attributes.present?
          delete_not_valid_attributes attributes
          define_serializable_attributes attributes
        end
        super attributes
      end

      def to_hash
        ActiveSupport::JSON.decode(to_json).with_indifferent_access
      end

      private

      def define_serializable_attributes(attributes)
        self.class.send(:define_method, :attributes) do
          Hash[attributes.keys.map { |x| [x, nil] }]
        end
      end

      def delete_not_valid_attributes(attributes)
        [:attributes].each do |reserved_key|
          attributes.delete(reserved_key)
        end
        attributes.each do |key, _|
          attributes.delete(key) unless self.class.attribute_method? key.to_sym
        end
        attributes
      end
    end

    autoload :News, 'hackernews/entities/news'
    autoload :User, 'hackernews/entities/user'
  end
end
