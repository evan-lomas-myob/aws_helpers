require 'rspec'
require 'aws_helpers/common/client'

describe AwsHelpers::Common::Client do

  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }

  it "should call AwsHelpers::Common::Config's initialize method" do
    expect(AwsHelpers::Common::Client).to receive(:new).with(options).and_return(AwsHelpers::Common::Config)
    AwsHelpers::Common::Client.new(options)
  end

  it 'should call the common config which should add retry_limit = 5' do
    expect(AwsHelpers::Common::Config.new(options).options).to match(hash_including(:retry_limit => 5))
  end

end