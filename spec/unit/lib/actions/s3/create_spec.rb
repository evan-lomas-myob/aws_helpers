require 'aws_helpers/config'
require 'aws_helpers/actions/s3/create'
require 'aws_helpers/actions/s3/exists'

include AwsHelpers::Actions::S3

describe S3Create do
  let(:aws_s3_client) { instance_double(Aws::S3::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_s3_client: aws_s3_client) }
  let(:s3_exists) { instance_double(S3Exists) }

  let(:s3_bucket_name) { 'my-bucket' }

  let(:acl) { 'public-read' }
  let(:stdout) { instance_double(IO) }

  let(:options) { {acl: acl, stdout: stdout} }

  let(:location) { 'Sydney' }
  let(:bucket_location) { instance_double(Aws::S3::Types::CreateBucketOutput, location: location) }


  before(:each) do
    allow(S3Exists).to receive(:new).and_return(s3_exists)
    allow(stdout).to receive(:puts).with(anything)
  end

  after(:each) {
    AwsHelpers::Actions::S3::S3Create.new(config, s3_bucket_name, options).execute
  }

  context 'Bucket does not exist' do

    before(:each) do
      allow(aws_s3_client).to receive(:create_bucket).with(acl: anything, bucket: s3_bucket_name).and_return(bucket_location)
      allow(s3_exists).to receive(:execute).and_return(false)
      allow(aws_s3_client).to receive(:wait_until)
    end

    it 'should create the new bucket' do
      expect(aws_s3_client).to receive(:create_bucket).with(acl: 'public-read', bucket: s3_bucket_name).and_return(bucket_location)
    end

    it 'should wait until the bucket is created' do
      expect(aws_s3_client).to receive(:wait_until).with(:bucket_exists, bucket: s3_bucket_name)
    end

    it 'should receive a message saying the bucket was created' do
      expect(stdout).to receive(:puts).with("Created S3 Bucket #{s3_bucket_name}")
    end
  end

  context 'Bucket already exists' do

    it 'should skip creating the bucket' do
      allow(s3_exists).to receive(:execute).and_return(true)
      expect(stdout).to receive(:puts).with("#{s3_bucket_name} already exists")
    end

  end

end
