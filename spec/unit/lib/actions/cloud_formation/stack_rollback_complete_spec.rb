require 'aws_helpers'

describe AwsHelpers::Actions::CloudFormation::StackRollbackComplete do
  let(:cloudformation_client) { instance_double(Aws::CloudFormation::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_cloud_formation_client: cloudformation_client) }

  let(:stack_name) { 'my_stack_name' }

  subject { AwsHelpers::Actions::CloudFormation::StackRollbackComplete.new(config, stack_name).execute }

  it 'should return true if stack is in status ROLLBACK_COMPLETE' do
    allow(cloudformation_client).to receive(:describe_stacks).with(stack_name: stack_name).and_return(create_response('ROLLBACK_COMPLETE'))
    expect(subject).to eq(true)
  end

  it 'should return false if stack is any other status' do
    allow(cloudformation_client).to receive(:describe_stacks).with(stack_name: stack_name).and_return(create_response('CREATE_COMPLETE'))
    expect(subject).to eq(false)
  end

  def create_response(status)
    stack = Aws::CloudFormation::Types::Stack.new(stack_status: status)
    Aws::CloudFormation::Types::DescribeStacksOutput.new(stacks: [stack])
  end
end
