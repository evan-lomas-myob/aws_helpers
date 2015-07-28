require 'rspec'
require 'aws_helpers/cloud_formation/client'

describe AwsHelpers::CloudFormation::Client do

  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }

  describe '.new' do

    it "should call AwsHelpers::CloudFormation::Client's initialize method" do
      expect(AwsHelpers::CloudFormation::Client).to receive(:new).with(options)
      AwsHelpers::CloudFormation::Client.new(options)
    end

  end

  describe 'CloudFormation Config methods' do

    it 'should create an instance of Aws::CloudFormation::Client' do
      expect(AwsHelpers::CloudFormation::Config.new(options).aws_cloud_formation_client).to match(Aws::CloudFormation::Client)
    end

    it 'should create an instance of Aws::S3::Client' do
      expect(AwsHelpers::CloudFormation::Config.new(options).aws_s3_client).to match(Aws::S3::Client)
    end

  end


end