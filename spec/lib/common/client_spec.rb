require 'rspec'
require 'aws_helpers/common/client'

describe AwsHelpers::Common::Client do

  let(:config) { 'my_config' }

  it 'should call the common client config accessor and return config' do
    expect(AwsHelpers::Common::Client.new(config).config).to match('my_config')
  end

end