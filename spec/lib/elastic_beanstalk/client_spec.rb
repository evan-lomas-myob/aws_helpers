require 'rspec'
require 'aws_helpers/elastic_beanstalk/client'

describe AwsHelpers::ElasticBeanstalk::Client do

  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }
  let(:elastic_beanstalk_version) { double(AwsHelpers::ElasticBeanstalk::Version) }
  let(:application) { 'my_application' }
  let(:environment) { 'my_env' }
  let(:version) { 'my_version' }

  describe '.new' do

    it "should call AwsHelpers::Common::Client's initialize method" do
      expect(AwsHelpers::Common::Client).to receive(:new).with(options).and_return(AwsHelpers::ElasticBeanstalk::Config)
      AwsHelpers::ElasticBeanstalk::Client.new(options)
    end

  end

end