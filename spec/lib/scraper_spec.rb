require 'spec_helper'

RSpec.describe Hackernews::Scraper do
  describe 'pages' do
    subject { scraper.pages(start, stop) }

    context 'with start and stop params' do
      let(:start) { 1 }
      let(:stop) { 1 }

      it 'returns an Array of News class objects' do
        expect(subject).to be_a Array
        expect(subject.all?(Hackernews::Entities::News)).to be_truthy
        expect(subject.size).to eq 30
      end
    end
  end
end
