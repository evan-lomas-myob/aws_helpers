require 'aws_helpers/config'
require 'aws_helpers/actions/s3/bucket_website'

include AwsHelpers::Actions::S3

describe S3BucketWebsite do

  let(:aws_s3_client) { instance_double(Aws::S3::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_s3_client: aws_s3_client) }
  let(:s3_exists) { instance_double(AwsHelpers::Actions::S3::S3Exists) }
  let(:stdout) { instance_double(IO) }

  let(:s3_bucket_name) { 'my-bucket' }
  let(:index_document) { 'index.html' }
  let(:error_document) { 'error.html' }

  let(:not_found) { Aws::S3::Errors::NotFound.new(config, '') }
  let(:website_configuration) { instance_double(Aws::S3::Types::WebsiteConfiguration, index_document: {key: index_document}) }

  it 'sets the website configuration for the bucket' do
    allow(AwsHelpers::Actions::S3::S3Exists).to receive(:new).with(config, s3_bucket_name).and_return(s3_exists)
    allow(s3_exists).to receive(:execute).and_return(true)
    expect(aws_s3_client).to receive(:put_bucket_website).with(bucket: s3_bucket_name, website_configuration: website_configuration)
    AwsHelpers::Actions::S3::S3BucketWebsite.new(config, s3_bucket_name, website_configuration, stdout).execute
  end

  it 'should return a message if the bucket does not exist' do
    allow(AwsHelpers::Actions::S3::S3Exists).to receive(:new).with(config, s3_bucket_name).and_return(s3_exists)
    allow(s3_exists).to receive(:execute).and_raise(not_found)
    allow(stdout).to receive(:puts).and_return("The S3 Bucket #{s3_bucket_name} does not exist")
    expect(AwsHelpers::Actions::S3::S3BucketWebsite.new(config, s3_bucket_name, website_configuration, stdout).execute).to eq("The S3 Bucket #{s3_bucket_name} does not exist")
  end

end