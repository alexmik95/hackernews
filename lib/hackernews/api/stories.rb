class Hackernews::API::Stories < Hackernews::API::Base
  def top(size = nil)
    response = @client.get(endpoint: '/v0/topstories.json')
    size.nil? ? extract_news(response) : extract_n_news(response, size)
  end

  def new(size = 0)
    response = @client.get(endpoint: '/v0/newstories.json')
    size.nil? ? extract_news(response) : extract_n_news(response, size)
  end

  def best(size = 0)
    response = @client.get(endpoint: '/v0/beststories.json')
    size.nil? ? extract_news(response) : extract_n_news(response, size)
  end

  def ask(size = 0)
    response = @client.get(endpoint: '/v0/askstories.json')
    size.nil? ? extract_news(response) : extract_n_news(response, size)
  end

  def show(size = 0)
    response = @client.get(endpoint: '/v0/showstories.json')
    size.nil? ? extract_news(response) : extract_n_news(response, size)
  end

  def job(size = 0)
    response = @client.get(endpoint: '/v0/jobstories.json')
    size.nil? ? extract_news(response) : extract_n_news(response, size)
  end

  def extract_news(response)
    [].tap do |news|
      print "fetching(#{response.size}) "
      Array.wrap(response).each do |id|
        print '.'
        tmp = fetch_item(id)
        if tmp[:type] == 'story' && !tmp[:url].to_s.strip.empty?
          news << build(tmp)
        end
      end
    end
  end

  def extract_n_news(response, n)
    if n.negative? || n > response.size
      raise Hackernews::Error::BadRequest, "bounds[0,#{response.size}]"
    end

    [].tap do |news|
      print "fetching(#{n}) "
      n.times do |i|
        print '.'
        tmp = fetch_item(response[i])
        if tmp[:type] == 'story' && !tmp[:url].to_s.strip.empty?
          news << build(tmp)
        end
      end
    end
  end

  def fetch_item(id)
    @client.get(endpoint: "/v0/item/#{id}.json")
  end

  def build(params)
    Hackernews::Entities::News.new(params)
  end
end
