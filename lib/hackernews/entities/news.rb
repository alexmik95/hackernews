class Hackernews::Entities::News < Hackernews::Entities::Base
  attr_accessor :by,
                :descendants,
                :id,
                :kids,
                :score,
                :text,
                :time,
                :title,
                :type,
                :url

  def inspect
    print "News { id: #{id}, title: #{title}, url: #{url} }"
  end

  def brief_hash
    {
      id: id,
      title: title,
      url: url
    }
  end
end
