require 'aws-sdk-core'
require 'aws_helpers/config'
require 'aws_helpers/actions/cloud_formation/stack_rollback_complete'

include Aws::CloudFormation::Types
include AwsHelpers::Actions::CloudFormation

describe StackRollbackComplete do

  let(:cloudformation_client) { instance_double(Aws::CloudFormation::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_cloud_formation_client: cloudformation_client) }

  let(:stack_name) { 'my_stack_name' }

  let(:stack_rollback_complete) { [
      instance_double(Aws::CloudFormation::Stack, stack_name: stack_name, stack_status: 'ROLLBACK_COMPLETE')
  ] }

  let(:stack_create_complete) { [
      instance_double(Aws::CloudFormation::Stack, stack_name: stack_name, stack_status: 'CREATE_COMPLETE')
  ] }

  let(:stack_rolledback) { instance_double(DescribeStacksOutput, stacks: stack_rollback_complete) }
  let(:stack_ok_response) { instance_double(DescribeStacksOutput, stacks: stack_create_complete) }

  it 'should return false if stack is in status ROLLBACK_COMPLETE' do
    allow(cloudformation_client).to receive(:describe_stacks).with(stack_name: stack_name).and_return(stack_rolledback)
    expect(StackRollbackComplete.new(config, stack_name).execute).to eq(true)
  end

  it 'should return false if stack is not status ROLLBACK_COMPLETE' do
    allow(cloudformation_client).to receive(:describe_stacks).with(stack_name: stack_name).and_return(stack_ok_response)
    expect(StackRollbackComplete.new(config, stack_name).execute).to eq(false)
  end

end