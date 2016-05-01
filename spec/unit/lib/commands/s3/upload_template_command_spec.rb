require 'aws_helpers/config'
require 'aws_helpers/commands/s3/upload_template_command'
require 'aws_helpers/requests/request'

UploadTemplateRequest = AwsHelpers::Requests::Request.new(:stdout, :stack_name, :bucket_name, :bucket_encrypt, :template_json)

describe AwsHelpers::Commands::S3::UploadTemplateCommand do
  describe '#execute' do
    let(:aws_s3_client) { instance_double(Aws::S3::Client) }
    let(:config) { instance_double(AwsHelpers::Config, aws_s3_client: aws_s3_client) }
    let(:stdout) { instance_double(IO) }

    let(:stack_name) { 'stack_name' }
    let(:bucket_name) { 'bucket_name' }
    let(:template_json) { '{ "template": "content" }' }
    let(:request) { UploadTemplateRequest.new(
        stdout: stdout,
        stack_name: stack_name,
        bucket_name: bucket_name,
        template_json: template_json) }

    before(:each) do
      allow(aws_s3_client).to receive(:put_object)
      allow(stdout).to receive(:puts)
    end

    after(:each) do
      described_class.new(config, request).execute
    end

    context 'bucket_encrypt set in the request' do
      it 'should call aws_s3_client #put_object with the correct parameters and server_side_encryption set to AES256' do
        request.bucket_encrypt = true
        expect(aws_s3_client).to receive(:put_object).with(bucket: bucket_name, key: stack_name, body: template_json, server_side_encryption: 'AES256')
      end
    end

    context 'bucket_encrypt undefined' do
      it 'should call aws_s3_client #put_object with the correct parameters' do
        expect(aws_s3_client).to receive(:put_object).with(bucket: bucket_name, key: stack_name, body: template_json)
      end
    end

    it 'should call stdout #puts with details of the bucket upload' do
      expect(stdout).to receive(:puts).with("Uploading #{stack_name} to S3 bucket #{bucket_name}")
    end
  end
end