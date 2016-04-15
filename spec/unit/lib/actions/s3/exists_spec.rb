require 'aws_helpers/config'
require 'aws_helpers/actions/s3/exists'

include AwsHelpers::Actions::S3

describe Exists do
  let(:aws_s3_client) { instance_double(Aws::S3::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_s3_client: aws_s3_client) }

  let(:s3_bucket_name) { 'my-bucket' }
  let(:s3_other_buckets) { 'other-buckets' }

  it 'should return true if a s3 bucket exists' do
    allow(aws_s3_client).to receive(:list_buckets).and_return(create_response(s3_bucket_name))
    expect(Exists.new(config, s3_bucket_name).execute).to eq(true)
  end

  it 'should return false if the bucket doesn\'t exist' do
    allow(aws_s3_client).to receive(:list_buckets).and_return(create_response(s3_other_buckets))
    expect(Exists.new(config, s3_bucket_name).execute).to eq(false)
  end

  def create_response(bucket_name)
    bucket = Aws::S3::Types::Bucket.new(name: bucket_name)
    Aws::S3::Types::ListBucketsOutput.new(buckets: [bucket])
  end

end
