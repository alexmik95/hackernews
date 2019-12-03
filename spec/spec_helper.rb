require 'hackernews'
require 'dotenv/load'
require 'bundler/setup'

Dotenv.overload('.env', '.env.test')

Dir[Pathname.new(File.dirname(__dir__)).join('spec/support/**/*.rb')].each do |file|
  require file
end

module FixtureHelpers
  def response_fixture(name)
    File.open("spec/fixtures/response/#{name}.json").read
  end
end

module TestHelpers
  extend ActiveSupport::Concern

  def client
    @client ||= Hackernews::Client.new(api)
  end

  def api
    @api ||= Hackernews::API.new(
      url: ENV['HN_API_URL']
    )
  end

  def scraper
    @scraper ||= Hackernews::Scraper.new(
      url: ENV['HN_HOST_URL']
    )
  end
end

RSpec.configure do |config|
  config.include TestHelpers
  config.include FixtureHelpers
  config.include VCRTestHelpers, vcr: true

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
