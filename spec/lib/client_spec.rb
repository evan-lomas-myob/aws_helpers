require 'aws_helpers/client'

describe 'Calling the config configure method' do

  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }

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

    context 'yield when called with a block' do

      let(:config) { double(AwsHelpers::Config) }

      it 'should call the client configure method with a block and return a config' do
        expect(client).to receive(:configure).and_return(config)
        client.configure { config }
      end

    end
  end
end