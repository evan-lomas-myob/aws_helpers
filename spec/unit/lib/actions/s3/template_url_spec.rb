require 'aws_helpers/config'
require 'aws_helpers/actions/s3/template_url'

include AwsHelpers::Actions::S3

describe TemplateUrl do
  let(:aws_s3_client) { instance_double(Aws::S3::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_s3_client: aws_s3_client) }
  let(:s3_exists) { instance_double(AwsHelpers::Actions::S3::Exists) }

  let(:stack_name) { 'stack_name' }
  let(:location) { 'eu-west-1' }
  let(:s3_bucket_name) { 'my-bucket' }

  before(:each) do
    allow(AwsHelpers::Actions::S3::Exists).to receive(:new).and_return(s3_exists)
    allow(s3_exists).to receive(:execute)
  end

  subject { AwsHelpers::Actions::S3::TemplateUrl.new(config, s3_bucket_name, stack_name).execute }

  context 'bucket exists' do
    before(:each) do
      allow(s3_exists).to receive(:execute).and_return(true)
      allow(aws_s3_client).to receive(:get_bucket_location).and_return(
          Aws::S3::Types::GetBucketLocationOutput.new(location_constraint: location)
      )
    end

    it 'should get the bucket location from the s3 client' do
      expect(aws_s3_client).to receive(:get_bucket_location).with(bucket: s3_bucket_name)
      subject
    end

    it 'should return the URL of the bucket' do
      expect(subject).to eq("https://s3-#{location}.amazonaws.com/#{s3_bucket_name}/#{stack_name}")
    end
  end

  context 'bucket does not exist' do
    before(:each) do
      allow(s3_exists).to receive(:execute).and_return(false)
    end

    it 'should return nil if the bucket does not exist' do
      expect(subject).to be_nil
    end
  end
end
