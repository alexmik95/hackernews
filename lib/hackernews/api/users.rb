class Hackernews::API::Users < Hackernews::API::Base
  def find(username: '')
    build @client.get(endpoint: "/v0/user/#{username}.json")
  end

  def build(params)
    Hackernews::Entities::User.new(params)
  end
end
