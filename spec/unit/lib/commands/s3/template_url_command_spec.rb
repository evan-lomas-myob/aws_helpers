require 'aws-sdk-core'
require 'aws_helpers/config'
require 'aws_helpers/commands/s3/template_url_command'
require 'aws_helpers/requests/request'

TemplateUrlRequest = AwsHelpers::Requests::Request.new(:stack_name, :bucket_name, :template_url)

describe AwsHelpers::Commands::S3::TemplateUrlCommand do
  describe '#execute' do
    let(:aws_s3_client) { instance_double(Aws::S3::Client) }
    let(:config) { instance_double(AwsHelpers::Config, aws_s3_client: aws_s3_client) }
    let(:s3_exists) { instance_double(AwsHelpers::Actions::S3::Exists) }

    let(:stack_name) { 'stack_name' }
    let(:location) { 'location' }
    let(:bucket_name) { 'bucket_name' }
    let(:request) { TemplateUrlRequest.new(stack_name: stack_name, bucket_name: bucket_name) }

    subject { described_class.new(config, request).execute }

    before(:each) do
      allow(aws_s3_client).to receive(:get_bucket_location).and_return(
          Aws::S3::Types::GetBucketLocationOutput.new(location_constraint: location)
      )
    end

    it 'should get the bucket location from the s3 client' do
      expect(aws_s3_client).to receive(:get_bucket_location).with(bucket: bucket_name)
      subject
    end

    it 'should set the template_url of the request' do
      subject
      expect(request.template_url).to eq("https://s3-#{location}.amazonaws.com/#{bucket_name}/#{stack_name}")
    end

  end
end