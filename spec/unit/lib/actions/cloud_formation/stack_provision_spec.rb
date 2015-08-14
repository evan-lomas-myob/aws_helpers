require 'aws-sdk-core'
require 'aws-sdk-resources'
require 'aws_helpers/cloud_formation'
require 'aws_helpers/actions/cloud_formation/stack_provision'
require 'aws_helpers/actions/cloud_formation/stack_upload_template'

include AwsHelpers
include Aws::CloudFormation::Types
include AwsHelpers::Actions::CloudFormation

describe StackProvision do

  let(:cloudformation_client) { instance_double(Aws::CloudFormation::Client) }
  let(:aws_s3_client) { instance_double(Aws::S3::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_cloud_formation_client: cloudformation_client, aws_s3_client: aws_s3_client) }
  let(:stack_upload_template) { instance_double(StackUploadTemplate) }

  let(:stdout) { instance_double(IO) }

  let(:stack_name) { 'my_stack_name' }
  let(:template_json) { 'json' }
  let(:capabilities) { ["CAPABILITY_IAM"] }

  let(:parameters) { [
      Parameter.new(parameter_key: 'param_key_1', parameter_value: 'param_value_1'),
      Parameter.new(parameter_key: 'param_key_2', parameter_value: 'param_value_1')
  ] }

  # let(:s3_bucket_name) { nil }
  let(:s3_bucket_name) { 'my bucket' }
  let(:bucket_encrypt) { true }


  it 'should update the template if the template_s3_bucket is not nil' do
    allow(StackUploadTemplate).to receive(:new).with(config, stack_name, template_json, s3_bucket_name, bucket_encrypt, stdout).and_return(stack_upload_template)
    expect(stack_upload_template).to receive(:execute)
    StackProvision.new(config, stack_name, template_json, parameters, capabilities, s3_bucket_name, bucket_encrypt, stdout).execute
  end

  it 'should check if the stack create failed and rolled-back' do
  end

  it 'should check if the stack already exists' do
  end

  it 'should call update_stack if the stack already exists' do
  end

  it 'should create a new stack if the stack doesnt exist' do
  end

  it 'should get the stack outputs' do
  end


end