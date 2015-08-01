require 'rspec'
require 'aws_helpers/elastic_beanstalk'

describe AwsHelpers::ElasticBeanstalk do

  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }
  let(:elastic_beanstalk_version) { double(AwsHelpers::ElasticBeanstalk::Version) }
  let(:application) { 'my_application' }
  let(:environment) { 'my_env' }
  let(:version) { 'my_version' }

  context '.new' do

    it "should call AwsHelpers::Common::Client's initialize method" do
      expect(AwsHelpers::Common::Client).to receive(:new).with(options).and_return(AwsHelpers::Config)
      AwsHelpers::ElasticBeanstalk.new(options)
    end

  end

  it 'should create an instance of Aws::ElasticBeanstalk::Client' do
    expect(AwsHelpers::Config.new(options).aws_elastic_beanstalk_client).to match(Aws::ElasticBeanstalk::Client)
  end

  it 'should create an instance of Aws::S3::Client' do
    expect(AwsHelpers::Config.new(options).aws_s3_client).to match(Aws::S3::Client)
  end

  it 'should create an instance of Aws::IAM::Client' do
    expect(AwsHelpers::Config.new(options).aws_iam_client).to match(Aws::IAM::Client)
  end

end