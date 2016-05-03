require 'aws_helpers/config'
require 'aws_helpers/directors/s3/bucket_exists_director'
require 'aws_helpers/commands/s3/bucket_exists_command'
require 'aws_helpers/requests/s3/bucket_exists_request'

describe AwsHelpers::Directors::S3::BucketExistsDirector do
  describe '#exists' do
    let(:config) { instance_double(AwsHelpers::Config) }
    let(:bucket_exists_command) { instance_double(AwsHelpers::Commands::S3::BucketExistsCommand) }
    let(:exists) { true}
    let(:request) { AwsHelpers::Requests::S3::BucketExistsRequest.new(bucket_exists: exists) }

    subject { described_class.new(config).exists?(request) }

    before(:each) do
      allow(AwsHelpers::Commands::S3::BucketExistsCommand).to receive(:new).and_return(bucket_exists_command)
      allow(bucket_exists_command).to receive(:execute)
    end

    it 'should call AwsHelpers::Commands::S3::BucketExistsCommand #new with correct parameters' do
      expect(AwsHelpers::Commands::S3::BucketExistsCommand).to receive(:new).with(config, request)
      subject
    end

    it 'should execute the commands in the correct order' do
      expect(bucket_exists_command).to receive(:execute).ordered
      subject
    end

    it 'should return the result of the bucket existence' do
      expect(subject).to be(exists)
    end
  end
end