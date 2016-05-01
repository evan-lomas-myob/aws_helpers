require 'aws_helpers/config'
require 'aws_helpers/commands/s3/bucket_exists_command'
require 'aws_helpers/requests/s3/bucket_exists_request'

describe AwsHelpers::Commands::S3::BucketExistsCommand do
  describe '#execute' do
    let(:aws_s3_client) { instance_double(Aws::S3::Client) }

    let(:config) { instance_double(AwsHelpers::Config, aws_s3_client: aws_s3_client) }

    let(:bucket_name) { 'name' }
    let(:request) { AwsHelpers::Requests::S3::BucketExistsRequest.new(bucket_name: bucket_name) }

    subject { described_class.new(config, request).execute }

    it 'should call Aws::S3::Client #list_buckets' do
      expect(aws_s3_client).to receive(:list_buckets).and_return(Aws::S3::Types::ListBucketsOutput.new(buckets: []))
      subject
    end

    context 'bucket is returned in the list' do
      it 'should set the request #bucket_exists to true' do
        allow(aws_s3_client).to receive(:list_buckets).and_return(create_response(bucket_name))
        subject
        expect(request.bucket_exists).to be_truthy
      end
    end

    context 'the bucket is not in the list' do
      it 'should set the request #bucket_exists to false' do
        allow(aws_s3_client).to receive(:list_buckets).and_return(create_response('another_name'))
        subject
        expect(request.bucket_exists).to be_falsey
      end
    end

    def create_response(bucket_name)
      bucket = Aws::S3::Types::Bucket.new(name: bucket_name)
      Aws::S3::Types::ListBucketsOutput.new(buckets: [bucket])
    end
  end
end