require 'aws_helpers/config'
require 'aws_helpers/commands/s3/bucket_create_command'
require 'aws_helpers/requests/s3/bucket_create_request'

describe AwsHelpers::Commands::S3::BucketCreateCommand do
  describe '#execute' do
    let(:aws_s3_client) { instance_double(Aws::S3::Client) }
    let(:config) { instance_double(AwsHelpers::Config, aws_s3_client: aws_s3_client) }
    let(:stdout) { instance_double(IO) }

    before(:each) do
      allow(stdout).to receive(:puts)
      allow(aws_s3_client).to receive(:create_bucket)
    end

    context 'bucket name undefined' do
      let(:request) { AwsHelpers::Requests::S3::BucketCreateRequest.new(stdout: stdout) }

      after(:each) do
        described_class.new(config, request).execute
      end

      it 'should not try to create the bucket' do
        expect(aws_s3_client).not_to receive(:create_bucket)
      end

    end

    context 'bucket name provided' do

      let(:bucket_name) { 'name' }
      let(:request) { AwsHelpers::Requests::S3::BucketCreateRequest.new(stdout: stdout, bucket_name: bucket_name) }

      after(:each) do
        described_class.new(config, request).execute
      end

      context 'bucket exists' do
        it 'should not try to create the bucket' do
          request.bucket_exists = true
          expect(aws_s3_client).not_to receive(:create_bucket)
        end
      end

      context 'bucket does not exist' do
        before(:each) do
          request.bucket_exists = false
        end

        it 'should call stdout with the details of bucket creation' do
          expect(stdout).to receive(:puts).with("Creating S3 Bucket #{bucket_name}")
        end

        context 'acl provided' do
          let(:acl) { 'acl' }

          it 'should call Aws::S3::Client #create_bucket with the correct parameters' do
            request.bucket_acl = acl
            expect(aws_s3_client).to receive(:create_bucket).with(bucket: bucket_name, acl: acl)
          end
        end

        context 'acl undefined' do
          it 'should call Aws::S3::Client #create_bucket with the correct parameters and acl defaulted to private' do
            expect(aws_s3_client).to receive(:create_bucket).with(bucket: bucket_name, acl: 'private')
          end
        end
      end
    end
  end
end