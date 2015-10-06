require 'aws_helpers/config'
require 'aws_helpers/actions/s3/exists'

include AwsHelpers::Actions::S3

describe S3Exists do

  let(:aws_s3_client) { instance_double(Aws::S3::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_s3_client: aws_s3_client) }

  let(:response) { instance_double(Seahorse::Client::Response) }
  let(:not_found) { Aws::S3::Errors::NotFound.new(config, '') }

  let(:s3_bucket_name) { 'my-bucket' }
  let(:bucket) { instance_double(Aws::S3::Bucket, url: 's3-bucket-url') }

  it 'should return true if a s3 bucket exists' do
    allow(aws_s3_client).to receive(:wait_until)
    allow(aws_s3_client).to receive(:head_bucket).and_return(response)
    allow(Aws::S3::Bucket).to receive(:new).with(s3_bucket_name, client: aws_s3_client).and_return(bucket)
    expect(S3Exists.new(config, s3_bucket_name).execute).to eq(true)
  end

  it 'should return false if the bucket doesn\'t exist' do
    allow(aws_s3_client).to receive(:wait_until)
    allow(aws_s3_client).to receive(:head_bucket).and_raise(not_found)
    expect(S3Exists.new(config, s3_bucket_name).execute).to eq(false)
  end

end