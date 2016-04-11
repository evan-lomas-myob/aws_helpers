require 'aws_helpers/config'
require 'aws_helpers/actions/s3/put_object'
require 'aws_helpers/actions/s3/exists'

include AwsHelpers::Actions::S3

describe S3PutObject do
  let(:aws_s3_client) { instance_double(Aws::S3::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_s3_client: aws_s3_client) }

  let(:s3_bucket_name) { 'my-bucket' }
  let(:key_name) { 's3_file_name' }
  let(:body) { 'file_contents' }

  let(:stdout) { instance_double(IO) }
  let(:options) { {stdout: stdout }}

  before(:each) do
    allow(stdout).to receive(:puts).with(anything)
  end

  after(:each) {
    AwsHelpers::Actions::S3::S3PutObject.new(config, s3_bucket_name, key_name, body, options).execute
  }

  context 'Bucket exists' do

    before(:each) do
      allow(aws_s3_client).to receive(:put_object).with(bucket: s3_bucket_name, key: key_name, body: body)
    end

    it 'should receive a message saying the object was created' do
      expect(stdout).to receive(:puts).with("Create S3 Object #{key_name} in #{s3_bucket_name}")
    end

    it 'should create the new object' do
      expect(aws_s3_client).to receive(:put_object).with(bucket: s3_bucket_name, key: key_name, body: body)
    end

  end

end
