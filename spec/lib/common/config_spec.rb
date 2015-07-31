require 'rspec'
require 'aws_helpers/common/config'

describe AwsHelpers::Common::Config do

  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }

  it 'should call the common config which should add retry_limit = 5' do
    expect(AwsHelpers::Common::Config.new(options).options).to match(hash_including(:retry_limit => 5))
  end

end