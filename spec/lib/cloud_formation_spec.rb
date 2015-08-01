require 'rspec'
require 'aws_helpers/cloud_formation'
require 'aws_helpers/config'

describe AwsHelpers::CloudFormation do

  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }

  context '.new' do

    it "should call AwsHelpers::CloudFormation::Client's initialize method" do
      expect(AwsHelpers::CloudFormation).to receive(:new).with(options).and_return(AwsHelpers::Config)
      AwsHelpers::CloudFormation.new(options)
    end

  end

  context 'CloudFormation Config methods' do

    it 'should create an instance of Aws::CloudFormation::Client' do
      expect(AwsHelpers::Config.new(options).aws_cloud_formation_client).to match(Aws::CloudFormation::Client)
      AwsHelpers::CloudFormation.new(options)
    end

    it 'should create an instance of Aws::S3::Client' do
      expect(AwsHelpers::Config.new(options).aws_s3_client).to match(Aws::S3::Client)
      AwsHelpers::CloudFormation.new(options)
    end

  end

end
