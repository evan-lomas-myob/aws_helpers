require 'aws-sdk-core'
require 'aws-sdk-resources'
require 'aws_helpers/cloud_formation'
require 'aws_helpers/actions/cloud_formation/stack_exists'

include AwsHelpers
include Aws::CloudFormation::Types
include AwsHelpers::Actions::CloudFormation

describe StackExists do

  let(:cloudformation_client) { instance_double(Aws::CloudFormation::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_cloud_formation_client: cloudformation_client) }

  let(:stack_name) { 'my_stack_name' }
  let(:bad_stack_name) { 'bad_stack_name' }

  let(:stack) { instance_double(Aws::CloudFormation::Stack) }
  let(:stack_exists_response) { instance_double(DescribeStacksOutput, stacks: stack) }

  let(:validation_error_stack_not_exists) { Aws::CloudFormation::Errors::ValidationError.new(config, "Stack with id #{stack_name} does not exist") }
  let(:validation_error_general) { Aws::CloudFormation::Errors::ValidationError.new(config, "General Error") }

  it 'should create a CloudFormation::Stack resource' do
    allow(cloudformation_client).to receive(:describe_stacks).with(stack_name: stack_name).and_return(stack_exists_response)
    expect(StackExists.new(config, stack_name).execute).to eq(true)
  end

  it 'should raise an exception if stack does not exists and return false' do
    allow(cloudformation_client).to receive(:describe_stacks).with(stack_name: stack_name).and_raise(validation_error_stack_not_exists)
    expect(StackExists.new(config, stack_name).execute).to eq(false)
  end

  it 'any other exception gets raised' do
    allow(cloudformation_client).to receive(:describe_stacks).with(stack_name: stack_name).and_raise(validation_error_general)
    expect { StackExists.new(config, stack_name).execute }.to raise_error(validation_error_general)
  end

end