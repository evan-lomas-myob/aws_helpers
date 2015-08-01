require 'rspec'
require 'aws_helpers/client'

describe 'Calling the config configure method' do

  let(:config) { {test: 'value'} }
  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }

  let(:client) { double(AwsHelpers::Client) }

  it 'should call the client configure method' do
    allow(AwsHelpers::Client).to receive(:new).with(options).and_return(client)
    allow(client).to receive(:configure).and_return(config)

    expect(AwsHelpers::Client.new(options).configure).to eq(config)

  end

end