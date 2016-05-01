require 'aws_helpers/config'
require 'aws_helpers/directors/s3/bucket_create_director'
require 'aws_helpers/requests/s3/bucket_create_request'
require 'aws_helpers/commands/s3/bucket_exists_command'
require 'aws_helpers/commands/s3/bucket_create_command'
require 'aws_helpers/commands/s3/poll_bucket_exists_command'

describe AwsHelpers::Directors::S3::BucketCreateDirector do
  describe '#create' do
    let(:config) { instance_double(AwsHelpers::Config) }
    let(:bucket_exists_command) { instance_double(AwsHelpers::Commands::S3::BucketExistsCommand) }
    let(:bucket_create_command) { instance_double(AwsHelpers::Commands::S3::BucketCreateCommand) }
    let(:poll_bucket_exists_command) { instance_double(AwsHelpers::Commands::S3::PollBucketExistsCommand) }
    let(:request) { AwsHelpers::Requests::S3::BucketCreateRequest.new }

    before(:each) do
      allow(AwsHelpers::Commands::S3::BucketExistsCommand).to receive(:new).and_return(bucket_exists_command)
      allow(AwsHelpers::Commands::S3::BucketCreateCommand).to receive(:new).and_return(bucket_create_command)
      allow(AwsHelpers::Commands::S3::PollBucketExistsCommand).to receive(:new).and_return(poll_bucket_exists_command)
      allow(bucket_exists_command).to receive(:execute)
      allow(bucket_create_command).to receive(:execute)
      allow(poll_bucket_exists_command).to receive(:execute)
    end

    after(:each) do
      described_class.new(config).create(request)
    end

    it 'should call AwsHelpers::Commands::S3::BucketExistsCommand #new with correct parameters' do
      expect(AwsHelpers::Commands::S3::BucketExistsCommand).to receive(:new).with(config, request)
    end

    it 'should call AwsHelpers::Commands::S3::BucketCreateCommand #new with correct parameters' do
      expect(AwsHelpers::Commands::S3::BucketCreateCommand).to receive(:new).with(config, request)
    end

    it 'should call AwsHelpers::Commands::S3::PollBucketExistsCommand #new with correct parameters' do
      expect(AwsHelpers::Commands::S3::PollBucketExistsCommand).to receive(:new).with(config,request)
    end

    it 'should execute the commands in the correct order' do
      expect(bucket_exists_command).to receive(:execute).ordered
      expect(bucket_create_command).to receive(:execute).ordered
      expect(poll_bucket_exists_command).to receive(:execute).ordered
    end
  end
end