require 'spec_helper'

RSpec.describe Hackernews::Entities::News do
  describe 'Respond to' do
    subject { Hackernews::Entities::News.new }

    it { is_expected.to respond_to(:inspect) }
    it { is_expected.to respond_to(:brief_hash) }
  end

end
