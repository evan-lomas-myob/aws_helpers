require 'aws_helpers'

describe AwsHelpers::Actions::CloudFormation::CheckStackFailure do
  let(:cloudformation_client) { instance_double(Aws::CloudFormation::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_cloud_formation_client: cloudformation_client) }

  let(:stack_id) { 'name' }
  let(:create_complete) { create_response(stack_id, 'CREATE_COMPLETE') }

  subject { described_class.new(config, stack_id).execute }

  it 'should call the cloud formation clients #describe_stacks with correct parameters' do
    expect(cloudformation_client).to receive(:describe_stacks).with(stack_name: stack_id).and_return(create_complete)
    subject
  end

  it 'should simply return if status has not failed' do
    expect(cloudformation_client).to receive(:describe_stacks).and_return(create_complete)
    subject
  end

  %w(UPDATE_ROLLBACK_COMPLETE ROLLBACK_COMPLETE ROLLBACK_FAILED UPDATE_ROLLBACK_FAILED DELETE_FAILED).each do |failure|
    it "should raise when stack status is #{failure}" do
      allow(cloudformation_client).to receive(:describe_stacks).and_return(create_response(stack_id, failure))
      expect { subject }.to raise_error('Stack name Failed')
    end
  end

  def create_response(id, status)
    stack = Aws::CloudFormation::Types::Stack.new(stack_name: 'name', stack_id: id,  stack_status: status)
    Aws::CloudFormation::Types::DescribeStacksOutput.new(stacks: [stack])
  end
end
