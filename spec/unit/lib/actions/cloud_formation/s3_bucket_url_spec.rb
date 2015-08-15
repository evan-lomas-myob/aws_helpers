require 'aws_helpers/config'
require 'aws_helpers/actions/cloud_formation/s3_bucket_url'

include AwsHelpers::Actions::CloudFormation

describe S3BucketUrl do

  let(:aws_s3_client) { instance_double(Aws::S3::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_s3_client: aws_s3_client) }

  let(:s3_bucket_name) { 'my-bucket' }
  let(:bucket) { instance_double(Aws::S3::Bucket, url: 's3-bucket-url',) }

  it 'should return true if a s3 bucket exists' do
    allow(aws_s3_client).to receive(:wait_until)
    allow(aws_s3_client).to receive(:head_bucket).and_return(nil)
    allow(Aws::S3::Bucket).to receive(:new).with(s3_bucket_name, client: aws_s3_client).and_return(bucket)
    expect(S3BucketUrl.new(config, s3_bucket_name).execute).to eq('s3-bucket-url')
  end

  it 'should raise and error if s3 bucket does not exist' do
    allow(aws_s3_client).to receive(:wait_until)
    allow(aws_s3_client).to receive(:head_bucket).and_raise('Aws::S3::Errors::NotFound')
    expect { S3BucketUrl.new(config, s3_bucket_name).execute }.to raise_error('Aws::S3::Errors::NotFound')
  end

end