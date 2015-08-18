require 'aws_helpers/config'
require 'aws_helpers/actions/s3/s3_create'

include AwsHelpers::Actions::S3

describe S3Create do

  let(:aws_s3_client) { instance_double(Aws::S3::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_s3_client: aws_s3_client) }
  let(:stdout) { instance_double(IO)}

  let(:s3_bucket_name) { 'my-bucket' }

  let(:location) { 'Sydney' }
  let(:bucket_location) { instance_double(Aws::S3::Types::CreateBucketOutput, location: location) }

  before(:each) do
    allow(stdout).to receive(:puts).with(anything)
    allow(aws_s3_client).to receive(:wait_until)
  end

  it 'should create the new bucket' do
    expect(aws_s3_client).to receive(:create_bucket).with(acl: 'private', bucket: s3_bucket_name).and_return(bucket_location)
    AwsHelpers::Actions::S3::S3Create.new(config, s3_bucket_name, stdout).execute
  end

  it 'should wait until the bucket is created' do
    allow(aws_s3_client).to receive(:create_bucket).with(acl: 'private', bucket: s3_bucket_name).and_return(bucket_location)
    expect(aws_s3_client).to receive(:wait_until).with(:bucket_exists, bucket: s3_bucket_name)
    AwsHelpers::Actions::S3::S3Create.new(config, s3_bucket_name, stdout).execute
  end

  it 'should receive a message saying the bucket was created' do
    allow(aws_s3_client).to receive(:create_bucket).with(acl: 'private', bucket: s3_bucket_name).and_return(bucket_location)
    expect(stdout).to receive(:puts).with("Created S3 Bucket #{s3_bucket_name}")
    AwsHelpers::Actions::S3::S3Create.new(config, s3_bucket_name, stdout).execute
  end

end