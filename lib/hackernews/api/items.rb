class Hackernews::API::Items < Hackernews::API::Base
  def find(id)
    @client.get(endpoint: "/v0/item/#{id}.json")
  end

  def maxitem
    @client.get(endpoint: '/v0/maxitem.json')
  end

  def build(params)
    Hackernews::Entities::News.new(params)
  end
end
