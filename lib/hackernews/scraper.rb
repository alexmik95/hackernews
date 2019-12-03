require 'hackernews/version'
require 'hackernews/entities/news'

MIN_PAGE_NUMBER = 1
MAX_PAGE_NUMBER = 20
JSON_FILE = 'news.json'

module Hackernews
  class Scraper
    attr_reader :url, :connection

    def initialize(url:)
      @url = url
      initialize_connection
    end

    def initialize_connection
      @connection = Excon.new(
        url,
        headers: {
          Connection: 'keep-alive',
          Host: 'news.ycombinator.com',
        },
        connect_timeout: 100,
        read_timeout: 600,
        write_timeout: 600
      )
    end

    def get(page: 0)
      response = @connection.get(
        path: '/news',
        query: { p: page }
      )
      handleResponse(response, "#{self.class}##{__method__}")
    rescue Excon::Error
      raise Hackernews::Error::ExconError
    end

    def handleResponse(response, msg_prefix)
      case response.status
      when 200
        Nokogiri::HTML(response.body)
      when 400
        raise Hackernews::Error::BadRequest
      when 404
        raise Hackernews::Error::NotFound
      else
        raise Error, "#{msg_prefix} Got HTTP #{response.status} -> #{response.body}"
      end
    rescue Error => e
      response.body
    end

    def pages(start_page = MIN_PAGE_NUMBER, stop_page = MAX_PAGE_NUMBER)
      check_indexes(start_page, stop_page)
      # print 'scraping '
      news = []
      (start_page..stop_page).each do |page|
        # print '.'
        parsed = get(page: page)
        news += extract_news(parsed)
      end
      news
    end

    def check_indexes(start_page, stop_page)
      if start_page < MIN_PAGE_NUMBER || stop_page > MAX_PAGE_NUMBER
        raise StandardError, 'Page index out of bounds'
      elsif start_page > stop_page
        raise StandardError, 'Start page higer than Stop page'
      end
    end

    def extract_news(parsed)
      # parsed.css('a').css('.storylink').each do |a|
      #   post_title = a.text
      #   post_link = a['href']
      #   news.push(Hackernews::Entities::News.new({title: post_title, url: post_link}))
      # end
      [].tap do |news|
        parsed.xpath('//*[@class="athing"]').each do |row|
          tmp_id = row['id']
          tmp_url = row.xpath('td[@class="title"]/a')[0]['href']
          tmp_title = row.xpath('td[@class="title"]/a').text
          news << Hackernews::Entities::News.new(id: tmp_id, title: tmp_title, url: tmp_url)
        end
      end
    end

    def json(news)
      JSON.pretty_generate(
        [].tap do |index|
          news.each { |n| index << n.brief_hash }
        end
      )
    end

    def save_json(news, filename = JSON_FILE)
      File.open(filename, 'w') { |file| file << json(news) }
    rescue Errno::ENOENT
      raise Hackernews::Error::NotFound
    end

    def load_json(filename = JSON_FILE)
      [].tap do |news|
        JSON.parse(File.read(filename)).each do |item|
          news << Hackernews::Entities::News.new(item)
        end
      end
    rescue Errno::ENOENT
      raise Hackernews::Error::NotFound
    end

    def update_json(news, filename = JSON_FILE)
      saved = load_json(filename)
      updated = delete_duplicate(saved + news)
      save_json(updated, filename)
    end

    def delete_duplicate(news)
      news.uniq(&:id)
    end

    def inspect
      puts "Scraper { url: #{url}, connection: #{connection} }"
    end
  end
end
