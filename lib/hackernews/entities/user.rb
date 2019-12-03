class Hackernews::Entities::User < Hackernews::Entities::Base
  attr_accessor :about,
                :created,
                :delay,
                :id,
                :karma,
                :submitted

  def inspect
    puts "User { id: #{id}, karma: #{karma} }"
  end

  def brief_hash
    {
      id: id,
      karma: karma
    }
  end
end
