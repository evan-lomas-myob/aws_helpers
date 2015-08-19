require 'aws_helpers/config'
require 'aws_helpers/actions/s3/location'

include AwsHelpers::Actions::S3

describe S3Location do

  let(:aws_s3_client) { instance_double(Aws::S3::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_s3_client: aws_s3_client) }
  let(:stdout) { instance_double(IO) }

  let(:s3_bucket_name) { 'my-bucket' }

  let(:location) { 'Sydney' }
  let(:response) { instance_double(Seahorse::Client::Response, data: location) }

  let(:no_such_bucket) { Aws::S3::Errors::NoSuchBucket.new(config, '') }

  it 'should return the bucket location' do
    allow(aws_s3_client).to receive(:get_bucket_location).with(bucket: s3_bucket_name).and_return(response)
    expect(AwsHelpers::Actions::S3::S3Location.new(config, s3_bucket_name, stdout).execute).to eq(location)
  end

  it 'should catch and exception if the bucket does not exist' do
    allow(aws_s3_client).to receive(:get_bucket_location).with(bucket: s3_bucket_name).and_raise(no_such_bucket)
    expect(stdout).to receive(:puts).with("Cannot find bucket named #{s3_bucket_name}")
    AwsHelpers::Actions::S3::S3Location.new(config, s3_bucket_name, stdout).execute
  end

end