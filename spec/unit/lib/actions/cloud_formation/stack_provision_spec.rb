require 'aws-sdk-core'
require 'aws-sdk-resources'
require 'aws_helpers/cloud_formation'
require 'aws_helpers/actions/cloud_formation/stack_provision'
require 'aws_helpers/actions/cloud_formation/stack_upload_template'
require 'aws_helpers/actions/cloud_formation/stack_rollback_complete'
require 'aws_helpers/actions/cloud_formation/stack_delete'
require 'aws_helpers/actions/cloud_formation/stack_create_request_builder'
require 'aws_helpers/actions/cloud_formation/stack_exists'

include AwsHelpers
include Aws::CloudFormation::Types
include AwsHelpers::Actions::CloudFormation

describe StackProvision do

  let(:cloudformation_client) { instance_double(Aws::CloudFormation::Client) }
  let(:aws_s3_client) { instance_double(Aws::S3::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_cloud_formation_client: cloudformation_client, aws_s3_client: aws_s3_client) }
  let(:s3_template_url) { instance_double(S3TemplateUrl) }
  let(:stack_upload_template) { instance_double(StackUploadTemplate) }
  let(:stack_rollback_complete) { instance_double(StackRollbackComplete) }
  let(:stack_delete) { instance_double(StackDelete) }
  let(:stack_request) { instance_double(StackCreateRequestBuilder) }
  let(:stack_exists) { instance_double(StackExists) }
  let(:stack_update) { instance_double(StackUpdate) }
  let(:stack_create) { instance_double(StackCreate) }

  let(:stdout) { instance_double(IO) }

  let(:stack_name) { 'my_stack_name' }
  let(:template_json) { 'json' }
  let(:capabilities) { ["CAPABILITY_IAM"] }

  let(:stack_rollback_complete) { [
      instance_double(Aws::CloudFormation::Stack, stack_name: stack_name, stack_status: 'ROLLBACK_COMPLETE')
  ] }

  let(:stack_rolledback) { instance_double(DescribeStacksOutput, stacks: stack_rollback_complete) }

  let(:parameters) { [
      Parameter.new(parameter_key: 'param_key_1', parameter_value: 'param_value_1'),
      Parameter.new(parameter_key: 'param_key_2', parameter_value: 'param_value_1')
  ] }

  let(:s3_bucket_name) { 'my bucket' }
  let(:bucket_encrypt) { true }
  let(:url) { 'https://my-bucket-url' }

  let(:request) { {stack_name: stack_name,
                   template_url: url,
                   parameters: parameters,
                   capabilities: capabilities
  } }

  let(:stack_exists_true) { true }
  let(:stack_exists_false) { false }

  let(:max_attempts) { 10 }
  let(:delay) { 30 }

  before (:each) do
    allow(aws_s3_client).to receive(:put_object)
    allow(aws_s3_client).to receive(:head_bucket)
    allow(stdout).to receive(:puts).with(anything)
    allow(StackUploadTemplate).to receive(:new).with(config, stack_name, anything, s3_bucket_name, bucket_encrypt, stdout).and_return(stack_upload_template)
    allow(stack_upload_template).to receive(:execute)
    allow(cloudformation_client).to receive(:describe_stacks).with(stack_name: stack_name).and_return(stack_rolledback)
    allow(cloudformation_client).to receive(:delete_stack).with(stack_name: stack_name)
    allow(cloudformation_client).to receive(:wait_until).with(anything, stack_name: stack_name)
    allow(StackDelete).to receive(:new).with(config, stack_name, stdout).and_return(stack_delete)
    allow(stack_delete).to receive(:execute)
    allow(StackCreateRequestBuilder).to receive(:new).with(stack_name, nil, template_json, parameters, capabilities).and_return(stack_request)
    allow(stack_request).to receive(:execute).and_return(request)
    allow(StackExists).to receive(:new).with(config, stack_name).and_return(stack_exists)
    allow(stack_exists).to receive(:execute).and_return(stack_exists_true)
    allow(StackUpdate).to receive(:new).with(config, stack_name, request, max_attempts, delay, stdout).and_return(stack_update)
    allow(stack_update).to receive(:execute)
  end

  after(:each) do
    StackProvision.new(config, stack_name, template_json, parameters, capabilities, s3_bucket_name, bucket_encrypt, stdout).execute
  end

  it 'should update the template if the template_s3_bucket is not nil' do
    expect(stack_upload_template).to receive(:execute)
  end

  it 'should check if the stack is in rolled-back state' do
    expect(cloudformation_client).to receive(:describe_stacks).with(stack_name: stack_name).and_return(stack_rolledback)
  end

  it 'should call stack delete if the stack is in rolled-back state' do
    expect(stack_delete).to receive(:execute)
  end

  it 'should create the stack creation request' do
    expect(stack_request).to receive(:execute).and_return(request)
  end

  it 'should check if the stack exists' do
    expect(stack_exists).to receive(:execute).and_return(stack_exists_true)
  end

  it 'should call create stack if the stack doesnt exist' do
    expect(stack_update).to receive(:execute)
  end

end