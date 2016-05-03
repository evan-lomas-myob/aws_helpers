require 'aws-sdk-core'
require 'aws_helpers/config'
require 'aws_helpers/commands/s3/poll_bucket_exists_command'
require 'aws_helpers/requests/s3/bucket_create_request'

describe AwsHelpers::Commands::S3::PollBucketExistsCommand do
  describe '#execute' do
    let(:aws_s3_client) { instance_double(Aws::S3::Client) }
    let(:config) { instance_double(AwsHelpers::Config, aws_s3_client: aws_s3_client) }
    let(:stdout) { instance_double(IO) }
    let(:request) {
      AwsHelpers::Requests::S3::BucketCreateRequest.new(
          stdout: stdout,
          bucket_polling: AwsHelpers::Requests::PollingRequest.new(
              delay: 0,
              max_attempts: 1
          )
      )
    }

    subject { described_class.new(config, request).execute }

    context 'bucket_name is undefined' do
      it 'should not call Aws::S3::Client #list_buckets' do
        expect(aws_s3_client).to_not receive(:list_buckets)
        subject
      end

      it 'should not call Aws::S3::Client #list_buckets' do
        subject
        expect(request.bucket_exists).to be_falsey
      end
    end

    context 'bucket_name provided' do
      let(:bucket_name) { 'name' }

      before(:each) {
        request.bucket_name = bucket_name
      }

      context 'bucket exists' do
        it 'should not call Aws::S3::Client #list_buckets' do
          request.bucket_exists = true
          expect(aws_s3_client).to_not receive(:list_buckets)
          subject
        end
      end

      context 'bucket does not exist' do
        before(:each) do
          allow(stdout).to receive(:puts)
        end

        it 'should call Aws::S3::Client #list_buckets until the bucket is found' do
          expect(aws_s3_client).to receive(:list_buckets).and_return(create_bucket_response(bucket_name))
          subject
        end

        it 'should set the requests bucket_exists property to be true' do
          allow(aws_s3_client).to receive(:list_buckets).and_return(create_bucket_response(bucket_name))
          subject
          expect(request.bucket_exists).to be_truthy
        end

        it 'should write to stdout that it is waiting for the bucket to be created' do
          allow(aws_s3_client).to receive(:list_buckets).and_return(create_bucket_response(bucket_name))
          expect(stdout).to receive(:puts).with("Waiting for S3 Bucket:#{bucket_name} to be created")
          subject
        end

        it 'should raise an error the bucket is not found after maximum polling attempts' do
          allow(aws_s3_client).to receive(:list_buckets).and_return(create_response([]))
          expect { subject }.to raise_error(Aws::Waiters::Errors::TooManyAttemptsError)
        end

      end

      def create_bucket_response(bucket_name)
        create_response([Aws::S3::Types::Bucket.new(name: bucket_name)])
      end

      def create_response(buckets)
        Aws::S3::Types::ListBucketsOutput.new(buckets: buckets)
      end

    end
  end
end