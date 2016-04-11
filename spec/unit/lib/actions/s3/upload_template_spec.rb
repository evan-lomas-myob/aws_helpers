require 'aws_helpers/config'
require 'aws_helpers/actions/s3/upload_template'
require 'aws_helpers/actions/s3/template_url'

include AwsHelpers::Actions::S3

describe S3UploadTemplate do
  let(:aws_s3_client) { instance_double(Aws::S3::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_s3_client: aws_s3_client) }

  let(:url) { 'https://my-bucket-url' }
  let(:stdout) { instance_double(IO) }
  let(:s3_create) { instance_double(S3Create) }
  let(:s3_put_object) { instance_double(S3PutObject) }
  let(:s3_template_url) { instance_double(S3TemplateUrl) }

  let(:stack_name) { 'my_stack_name' }
  let(:template_json) { '{ "template": "content" }' }

  let(:s3_bucket_name) { 'my bucket' }

  let(:create_options) { {stdout: stdout, server_side_encryption: 'AES256'} }
  let(:put_options) { {stdout: stdout, server_side_encryption: 'AES256'} }
  let(:options) { {bucket_encrypt: true, stdout: stdout} }
  let(:request) { {bucket: s3_bucket_name, key: stack_name, body: template_json} }

  before(:each) do
    allow(S3Create).to receive(:new).with(config, s3_bucket_name, create_options).and_return(s3_create)
    allow(s3_create).to receive(:execute)
    allow(S3PutObject).to receive(:new).with(config, s3_bucket_name, stack_name, template_json, put_options).and_return(s3_put_object)
    allow(s3_put_object).to receive(:execute)
    allow(S3TemplateUrl).to receive(:new).with(config, s3_bucket_name).and_return(s3_template_url)
    allow(s3_template_url).to receive(:execute)
    allow(stdout).to receive(:puts)
  end

  after(:each) do
    S3UploadTemplate.new(config, stack_name, template_json, s3_bucket_name, options).execute
  end

  it 'should return a message that it will upload a template' do
    expect(stdout).to receive(:puts).with("Uploading #{stack_name} to S3 bucket #{s3_bucket_name}")
  end

  it 'should create a new bucket' do
    expect(S3Create).to receive(:new).with(config, s3_bucket_name, create_options)
  end

  it 'should put the template in the s3 bucket' do
    expect(S3PutObject).to receive(:new).with(config, s3_bucket_name, stack_name, template_json, put_options)
  end

  it 'should return the s3 bucket url' do
    expect(S3TemplateUrl).to receive(:new).with(config, s3_bucket_name).and_return(s3_template_url)
  end
end
