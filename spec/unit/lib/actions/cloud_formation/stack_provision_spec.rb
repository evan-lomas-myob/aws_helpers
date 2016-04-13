require 'aws-sdk-core'
require 'aws_helpers/cloud_formation'
require 'aws_helpers/actions/cloud_formation/stack_provision'
require 'aws_helpers/actions/s3/upload_template'
require 'aws_helpers/actions/cloud_formation/stack_rollback_complete'
require 'aws_helpers/actions/cloud_formation/stack_delete'
require 'aws_helpers/actions/cloud_formation/stack_create_request_builder'
require 'aws_helpers/actions/cloud_formation/stack_exists'

include AwsHelpers
include Aws::CloudFormation::Types
include AwsHelpers::Actions::CloudFormation
include AwsHelpers::Actions::S3

describe StackProvision do
  let(:cloudformation_client) { instance_double(Aws::CloudFormation::Client) }
  let(:aws_s3_client) { instance_double(Aws::S3::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_cloud_formation_client: cloudformation_client, aws_s3_client: aws_s3_client) }
  let(:stack_upload_template) { instance_double(UploadTemplate) }
  let(:stack_rollback_complete) { instance_double(StackRollbackComplete) }
  let(:stack_delete) { instance_double(StackDelete) }
  let(:stack_request_url) { instance_double(StackCreateRequestBuilder) }
  let(:stack_request_body) { instance_double(StackCreateRequestBuilder) }
  let(:stack_information) { instance_double(StackInformation) }

  let(:stack_exists) { instance_double(StackExists) }
  let(:stack_update) { instance_double(StackUpdate) }
  let(:stack_create) { instance_double(StackCreate) }

  let(:stdout) { instance_double(IO) }

  let(:max_attempts) { 1 }
  let(:delay) { 1 }

  let(:stack_create_polling) { { max_attempts: max_attempts, delay: delay } }
  let(:stack_update_polling) { { max_attempts: max_attempts, delay: delay } }

  let(:options) { { stdout: stdout, stack_create_polling: stack_create_polling, stack_update_polling: stack_update_polling } }
  let(:stack_create_options) { { stdout: stdout, max_attempts: max_attempts, delay: delay } }
  let(:stack_update_options) { { stdout: stdout, max_attempts: max_attempts, delay: delay } }

  let(:stack_name) { 'my_stack_name' }
  let(:template_json) { 'json' }
  let(:capabilities) { ['CAPABILITY_IAM'] }

  let(:stack_rolledback) { create_response(stack_name, 'ROLLBACK_COMPLETE') }
  let(:stack_created) { create_response(stack_name, 'CREATE_COMPLETE') }

  let(:parameters) do
    [
      Parameter.new(parameter_key: 'param_key_1', parameter_value: 'param_value_1'),
      Parameter.new(parameter_key: 'param_key_2', parameter_value: 'param_value_1')
    ]
  end

  let(:outputs) { Output.new(output_key: 'output_key', output_value: 'output_value', description: nil) }

  let(:s3_bucket_name) { 'my bucket' }
  let(:bucket_encrypt) { true }
  let(:url) { 'https://my-bucket-url' }

  let(:request_with_url) do
    {
      stack_name: stack_name,
      template_url: url,
      parameters: parameters,
      capabilities: capabilities
    }
  end

  let(:request_with_body) do
    {
      stack_name: stack_name,
      template_body: template_json,
      parameters: parameters,
      capabilities: capabilities
    }
  end

  let(:stack_exists_true) { true }
  let(:stack_exists_false) { false }

  context 'template upload required' do
    before(:each) do
      allow(UploadTemplate).to receive(:new).and_return(stack_upload_template)
      allow(stack_upload_template).to receive(:execute).and_return(url)
      allow(cloudformation_client).to receive(:describe_stacks).and_return(stack_rolledback)
      allow(StackDelete).to receive(:new).and_return(stack_delete)
      allow(stack_delete).to receive(:execute)
      allow(StackCreateRequestBuilder).to receive(:new).and_return(stack_request_body)
      allow(stack_request_body).to receive(:execute).and_return(request_with_url)
      allow(StackExists).to receive(:new).and_return(stack_exists)
      allow(stack_exists).to receive(:execute).and_return(stack_exists_true)
      allow(StackUpdate).to receive(:new).and_return(stack_update)
      allow(stack_update).to receive(:execute)
      allow(StackCreate).to receive(:new).and_return(stack_create)
      allow(stack_create).to receive(:execute)
      allow(StackInformation).to receive(:new).and_return(stack_information)
      allow(stack_information).to receive(:execute).and_return(outputs)
    end

    after(:each) do
      StackProvision.new(config, stack_name, template_json, s3_bucket_name: s3_bucket_name).execute
    end

    it 'should upload the template if the s3_bucket_name is not nil' do
      expect(stack_upload_template).to receive(:execute)
    end

    it 'should check if the stack is in rolled-back state' do
      expect(cloudformation_client).to receive(:describe_stacks).with(stack_name: stack_name).and_return(stack_rolledback)
    end

    it 'should call stack delete if the stack is in rolled-back state' do
      expect(stack_delete).to receive(:execute)
    end

    it 'should create the stack creation request' do
      expect(stack_request_body).to receive(:execute).and_return(request_with_url)
    end

    it 'should check if the stack exists' do
      expect(stack_exists).to receive(:execute).and_return(stack_exists_true)
    end

    it 'should call update stack if the stack already exists' do
      expect(stack_update).to receive(:execute)
    end

    it 'should call create stack if the stack does not exists' do
      allow(StackExists).to receive(:new).with(config, stack_name).and_return(stack_exists)
      allow(stack_exists).to receive(:execute).and_return(stack_exists_false)
      expect(stack_create).to receive(:execute)
    end

    it 'should return the outputs' do
      expect(StackProvision.new(config, stack_name, template_json).execute).to eq(outputs)
    end
  end

  context 'no template upload required' do
    it 'should return a request template with template_body embedded' do
      allow(stdout).to receive(:puts)
      allow(cloudformation_client).to receive(:describe_stacks).with(stack_name: stack_name).and_return(stack_created)
      allow(StackCreateRequestBuilder).to receive(:new).and_return(stack_request_body)
      expect(stack_request_body).to receive(:execute).and_return(request_with_body)
      allow(StackUpdate).to receive(:new).and_return(stack_update)
      allow(stack_update).to receive(:execute)
      allow(StackInformation).to receive(:new).and_return(stack_information)
      allow(stack_information).to receive(:execute).and_return(outputs)
      StackProvision.new(config, stack_name, template_json).execute
    end
  end

  def create_response(name, status)
    Aws::CloudFormation::Types::DescribeStacksOutput.new(
      stacks: [
        Aws::CloudFormation::Types::Stack.new(stack_name: name, stack_status: status)
      ])
  end
end
