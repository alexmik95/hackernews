require 'spec_helper'

RSpec.describe Hackernews::Client do
  describe 'get' do
    subject { client.get endpoint: '/api' }

    context 'when response is valid' do
      before do
        allow(client.connection).to receive(:get).and_return(
          Excon::Response.new(status: 200, body: { foo: 'bar' }.to_json)
        )
      end
      it { expect(subject).to be_a Hash }
    end

    context 'when response is bad request' do
      before do
        allow(client.connection).to receive(:get).and_return(
          Excon::Response.new(status: 400, body: '')
        )
      end
      it { expect { subject }.to raise_error(Hackernews::Error::BadRequest) }
    end

    context 'when response is not found' do
      before do
        allow(client.connection).to receive(:get).and_return(
          Excon::Response.new(status: 404, body: '')
        )
      end
      it { expect { subject }.to raise_error(Hackernews::Error::NotFound) }
    end

    context 'when response contains a wrong code' do
      before do
        allow(client.connection).to receive(:get).and_return(
          Excon::Response.new(status: 666, body: '')
        )
      end
      it { expect { subject }.to raise_error(Hackernews::Error) }
    end
  end

end
