require 'aws_helpers/config'
require 'aws_helpers/actions/s3/s3_upload_template'
require 'aws_helpers/actions/s3/s3_template_url'

include AwsHelpers::Actions::S3

describe S3UploadTemplate do

  let(:aws_s3_client) { instance_double(Aws::S3::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_s3_client: aws_s3_client) }

  let(:url) { 'https://my-bucket-url' }
  let(:stdout) { instance_double(IO) }
  let(:s3_template_url) { instance_double(S3TemplateUrl) }

  let(:stack_name) { 'my_stack_name' }
  let(:template_json) { 'json' }

  let(:s3_bucket_name) { 'my bucket' }
  let(:bucket_encrypt) { true }

  let(:request) { {bucket: s3_bucket_name, key: stack_name, body: 'json', server_side_encryption: 'AES256'} }


  it 'should check if the s3 bucket exists' do

  end


  # before(:each) do
  #   allow(aws_s3_client).to receive(:put_object).with(request)
  #   allow(aws_s3_client).to receive(:head_bucket)
  #   allow(S3TemplateUrl).to receive(:new).with(config, s3_bucket_name).and_return(s3_template_url)
  #   allow(s3_template_url).to receive(:execute).and_return(url)
  #   allow(stdout).to receive(:puts).with(anything)
  # end

  # it 'should return a message that it will upload a template' do
  #   expect(stdout).to receive(:puts).with("Uploading #{stack_name} to S3 bucket #{s3_bucket_name}")
  #   S3UploadTemplate.new(config, stack_name, template_json, s3_bucket_name, bucket_encrypt, stdout).execute
  # end
  #
  # it 'should generate a request and call put_object' do
  #   expect(aws_s3_client).to receive(:put_object).with(request)
  #   S3UploadTemplate.new(config, stack_name, template_json, s3_bucket_name, bucket_encrypt, stdout).execute
  # end
  #
  # it 'should return the s3 bucket url' do
  #   expect(S3UploadTemplate.new(config, stack_name, template_json, s3_bucket_name, bucket_encrypt, stdout).execute).to eq(url)
  # end

end