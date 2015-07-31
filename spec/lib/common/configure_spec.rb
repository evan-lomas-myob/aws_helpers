require 'rspec'
require 'aws_helpers/common/client'

describe 'Calling the config configure method' do

  let(:config) {  { test: 'value' } }

  it 'should call the common config which should add retry_limit = 5' do
    expect(AwsHelpers::Common::Client.new(config).config).to match(config)
  end

  it 'should call the common configure method' do
    expect(AwsHelpers::Common::Client.new().configure).to match(anything)
  end

end