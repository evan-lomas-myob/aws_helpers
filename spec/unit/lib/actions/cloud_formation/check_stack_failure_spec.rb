require 'aws-sdk-core'
require 'aws_helpers/config'
require 'aws_helpers/actions/cloud_formation/check_stack_failure'

include Aws::CloudFormation::Types
include AwsHelpers::Actions::CloudFormation

describe CheckStackFailure do

  let(:cloudformation_client) { instance_double(Aws::CloudFormation::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_cloud_formation_client: cloudformation_client) }

  let(:stack_name) { 'my_stack_name' }

  let(:stack_failed) { [
      instance_double(Aws::CloudFormation::Stack, stack_name: stack_name, stack_status: 'UPDATE_ROLLBACK_COMPLETE')
  ] }

  let(:stack_ok) { [
      instance_double(Aws::CloudFormation::Stack, stack_name: stack_name, stack_status: 'CREATE_COMPLETE')
  ] }

  let(:stack_failed_response) { instance_double(DescribeStacksOutput, stacks: stack_failed) }
  let(:stack_ok_response) { instance_double(DescribeStacksOutput, stacks: stack_ok) }

  it 'should simply exit if status is ok' do
    expect(cloudformation_client).to receive(:describe_stacks).with(stack_name: stack_name).and_return(stack_ok_response)
    CheckStackFailure.new(config, stack_name).execute
  end

  it 'should raise if stack failed' do
    allow(cloudformation_client).to receive(:describe_stacks).with(stack_name: stack_name).and_return(stack_failed_response)
    expect { CheckStackFailure.new(config, stack_name).execute }.to raise_error("Stack #{stack_name} Failed")
  end

end