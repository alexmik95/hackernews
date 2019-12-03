module Hackernews
  class Client
    attr_reader :api, :connection

    def initialize(api)
      @connection = Excon.new(
        api.url,
        headers: {
          Connection: 'keep-alive',
          Host: 'hacker-news.firebaseio.com'
        },
        connect_timeout: 100,
        read_timeout: 600,
        write_timeout: 600
      )
      @api = api
    end

    def get(endpoint: '')
      response = @connection.get(
        path: endpoint,
        query: { print: 'pretty' }
      )
      handleResponse(response, "#{self.class}##{__method__}")
    rescue Excon::Error
      raise Hackernews::Error::ExconError
    end

    def handleResponse(response, msg_prefix)
      raise Hackernews::Error::NotFound if response.body == "null\n"

      case response.status
      when 200
        json_parse response
      when 400
        raise Hackernews::Error::BadRequest
      when 404
        raise Hackernews::Error::NotFound
      else
        raise Error, "#{msg_prefix} Got HTTP #{response.status} -> #{response.body}"
      end
    end

    def json_parse(response)
      JSON.parse(response.body, symbolize_names: true)
    rescue JSON::ParserError => e
      response.body
    end
  end
end
