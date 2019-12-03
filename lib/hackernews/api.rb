module Hackernews
  class API
    attr_reader :url

    def initialize(url:)
      @url = url
    end

    def items
      @items ||= Hackernews::API::Items.new(client)
    end

    def users
      @users ||= Hackernews::API::Users.new(client)
    end

    def stories
      @stories ||= Hackernews::API::Stories.new(client)
    end

    def client
      @client ||= Hackernews::Client.new(self)
    end

    class Base
      def initialize(client)
        @client = client
      end
    end
  end
end

Dir["#{File.dirname(__FILE__)}/api/*.rb"].each { |f| load(f) }
