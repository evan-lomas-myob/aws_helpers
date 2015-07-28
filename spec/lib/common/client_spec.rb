require 'rspec'
require 'aws_helpers/auto_scaling/config'

describe AwsHelpers::Common::Config do

  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }

  it "should call AwsHelpers::Common::Config's initialize method" do
    expect(AwsHelpers::AutoScaling::Config).to receive(:new).with(options)
    AwsHelpers::AutoScaling::Config.new(options)
  end

  it 'should call the AutoScaling config which should add retry_limit = 5' do
    expect(AwsHelpers::AutoScaling::Config.new(options).options).to match(hash_including(:retry_limit => 5))
  end

end