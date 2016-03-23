require 'aws_helpers/config'
require 'aws_helpers/actions/s3/exists'

include AwsHelpers::Actions::S3

describe S3Exists do

  let(:aws_s3_client) { instance_double(Aws::S3::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_s3_client: aws_s3_client) }

  let(:s3_bucket_name) { 'my-bucket' }

  it 'should return true if a s3 bucket exists' do
    allow(aws_s3_client).to receive(:head_bucket).and_return(Seahorse::Client::Response.new)
    expect(S3Exists.new(config, s3_bucket_name).execute).to eq(true)
  end

  it 'should return false if the bucket doesn\'t exist' do
    allow(aws_s3_client).to receive(:head_bucket).and_raise(Aws::S3::Errors::NotFound.new(nil, nil))
    expect(S3Exists.new(config, s3_bucket_name).execute).to eq(false)
  end

end