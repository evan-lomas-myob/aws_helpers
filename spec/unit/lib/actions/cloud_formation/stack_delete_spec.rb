require 'aws-sdk-core'
require 'aws_helpers/cloud_formation'
require 'aws_helpers/actions/cloud_formation/stack_exists'
require 'aws_helpers/actions/cloud_formation/stack_delete'

include AwsHelpers
include AwsHelpers::Actions::CloudFormation
include Aws::CloudFormation::Types

describe StackDelete do
  let(:cloudformation_client) { instance_double(Aws::CloudFormation::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_cloud_formation_client: cloudformation_client) }
  let(:stack_progress) { instance_double(StackProgress) }
  let(:stack_exists) { instance_double(StackExists) }
  let(:stdout) { instance_double(IO) }
  let(:stack_name) { 'my_stack_name' }
  let(:stack_id) { "arn:aws:cloudformation:region:id:stack/#{stack_name}/stack_id_number" }
  let(:options) { { stack_id: stack_id, stdout: stdout } }

  let(:describe_stack) { [instance_double(Stack, stack_name: stack_name, stack_id: stack_id)] }
  let(:describe_stack_response) { instance_double(DescribeStacksOutput, stacks: describe_stack) }

  before(:each) do
    allow(cloudformation_client).to receive(:delete_stack)
    allow(StackProgress).to receive(:new).with(config, options).and_return(stack_progress)
    allow(stack_progress).to receive(:execute)
    allow(StackExists).to receive(:new).with(config, stack_name).and_return(stack_exists)
    allow(stack_exists).to receive(:execute).and_return(true)
    allow(cloudformation_client).to receive(:describe_stacks).with(stack_name: stack_name).and_return(describe_stack_response)
    allow(stdout).to receive(:puts).with(anything)
  end

  after(:each) do
    AwsHelpers::Actions::CloudFormation::StackDelete.new(config, stack_name, stdout: stdout).execute
  end

  it 'should call delete_stack to remove the stack' do
    expect(cloudformation_client).to receive(:delete_stack).with(stack_name: stack_name)
  end

  it 'should poll for stack delete completion' do
    expect(stack_progress).to receive(:execute)
  end

  it 'should get output stating the stack was deleted' do
    expect(stdout).to receive(:puts).with('Deleting my_stack_name')
  end
end
