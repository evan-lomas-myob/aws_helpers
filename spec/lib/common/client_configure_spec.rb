require 'rspec'
require 'aws_helpers/common/client'

describe 'Calling the config configure method' do

  let(:config) { {test: 'value'} }
  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }

  let(:client) { double(AwsHelpers::Common::Client) }

  it 'should call the client configure method' do
    allow(AwsHelpers::Common::Client).to receive(:new).with(options).and_return(client)
    allow(client).to receive(:configure).and_return(config)

    expect(AwsHelpers::Common::Client.new(options).configure).to eq(config)

  end

end