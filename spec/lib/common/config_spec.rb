require 'rspec'
require 'aws_helpers/common/config'

describe AwsHelpers::Common::Config do

  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }
  let(:default_option) { { retry_limit: 5 } }

  it 'should call the common config which should add retry_limit = 5' do
    expect(AwsHelpers::Common::Config.new(options).options).to match(hash_including(default_option))
  end

end