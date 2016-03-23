require 'aws-sdk-core'
require 'aws_helpers/config'
require 'aws_helpers/actions/cloud_formation/check_stack_failure'
require 'aws_helpers/utilities/target_stack_validate'

describe AwsHelpers::Actions::CloudFormation::CheckStackFailure do

  let(:cloudformation_client) { instance_double(Aws::CloudFormation::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_cloud_formation_client: cloudformation_client) }
  let(:target_stack_validate) { instance_double(AwsHelpers::Utilities::TargetStackValidate) }

  let(:stack_name) { 'name' }
  let(:options) { { stack_name: stack_name } }
  let(:create_complete) { create_response(stack_name, 'CREATE_COMPLETE') }

  subject { AwsHelpers::Actions::CloudFormation::CheckStackFailure.new(config, options).execute }

  before(:each) do
    allow(AwsHelpers::Utilities::TargetStackValidate).to receive(:new).and_return(target_stack_validate)
    allow(target_stack_validate).to receive(:execute).and_return(stack_name)
  end

  it 'should validate options' do
    allow(cloudformation_client).to receive(:describe_stacks).and_return(create_complete)
    expect(target_stack_validate).to receive(:execute).with(options)
    subject
  end

  it 'should call the cloud formation clients #describe_stacks with correct parameters' do
    expect(cloudformation_client).to receive(:describe_stacks).with(stack_name: stack_name).and_return(create_complete)
    subject
  end

  it 'should simply return if status has not failed' do
    expect(cloudformation_client).to receive(:describe_stacks).and_return(create_complete)
    subject
  end

  %w(UPDATE_ROLLBACK_COMPLETE ROLLBACK_COMPLETE ROLLBACK_FAILED UPDATE_ROLLBACK_FAILED DELETE_FAILED).each { |failure|

    it "should raise when stack status is #{failure}" do
      allow(cloudformation_client).to receive(:describe_stacks).and_return(create_response(stack_name, failure))
      expect { subject }.to raise_error("Stack #{stack_name} Failed")
    end
  }

  def create_response(name, status)
    Aws::CloudFormation::Types::DescribeStacksOutput.new(stacks: [
      Aws::CloudFormation::Types::Stack.new(stack_name: name, stack_status: status)
    ])
  end

end