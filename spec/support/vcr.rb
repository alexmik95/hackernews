require 'vcr'

module VCRTestHelpers
  extend ActiveSupport::Concern

  included do
    VCR.configure do |vcr|
      vcr.cassette_library_dir = 'spec/fixtures/vcr'
      vcr.default_cassette_options = { allow_playback_repeats: true }
      vcr.hook_into :excon
      vcr.configure_rspec_metadata!
      vcr.allow_http_connections_when_no_cassette = true
      vcr.ignore_localhost = true
    end
  end
end

RSpec.configure do |config|
  config.include VCRTestHelpers, vcr: true
end
