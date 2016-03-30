require 'aws_helpers/client'

describe AwsHelpers::Client do
  let(:options) { { stub_responses: true, endpoint: 'http://endpoint' } }

  it '#initialize' do
    expect(AwsHelpers::Client).to receive(:new).with(options)
    AwsHelpers::Client.new(options)
  end

  describe '#configure' do
    let(:client) { AwsHelpers::Client.new(options) }

    context 'no block' do
      it 'should call the client configure method and return nil' do
        expect(client).to receive(:configure).and_return(nil)
        client.configure
      end
    end

    context 'block given' do
      let(:config) { instance_double(AwsHelpers::Config) }

      it 'should yield when a block is given' do
        expect { |config| client.configure(&config) }.to yield_control
      end

      it 'should yield and return a config' do
        expect(client).to receive(:configure).and_return(config)
        client.configure { config }
      end
    end
  end
end
