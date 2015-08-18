require 'aws_helpers/config'
require 'aws_helpers/actions/s3/s3_template_url'

include AwsHelpers::Actions::S3

describe S3TemplateUrl do

  let(:aws_s3_client) { instance_double(Aws::S3::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_s3_client: aws_s3_client) }

  let(:s3_exists) { instance_double(AwsHelpers::Actions::S3::S3Exists) }

  let(:s3_bucket_name) { 'my-bucket' }
  let(:url) { 's3-bucket-url' }
  let(:bucket) { instance_double(Aws::S3::Bucket, url: url) }

  let(:response) { instance_double(Seahorse::Client::Response) }

  it 'should return true if a s3 bucket exists' do
    allow(AwsHelpers::Actions::S3::S3Exists).to receive(:new).with(config, s3_bucket_name).and_return(s3_exists)
    allow(Aws::S3::Bucket).to receive(:new).with(s3_bucket_name, client: aws_s3_client).and_return(bucket)
    expect(s3_exists).to receive(:execute).and_return(true)
    AwsHelpers::Actions::S3::S3TemplateUrl.new(config, s3_bucket_name).execute
  end

  it 'should return the URL' do
    allow(aws_s3_client).to receive(:head_bucket)
    allow(Aws::S3::Bucket).to receive(:new).with(s3_bucket_name, client: aws_s3_client).and_return(bucket)
    expect(AwsHelpers::Actions::S3::S3TemplateUrl.new(config, s3_bucket_name).execute).to eq(url)
  end

end