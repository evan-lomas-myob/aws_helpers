require 'aws_helpers/cloud_formation'
require 'aws_helpers/actions/cloud_formation/stack_delete'

include AwsHelpers
include AwsHelpers::Actions::CloudFormation

describe StackDelete do

  let(:cloudformation_client) { instance_double(Aws::CloudFormation::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_cloud_formation_client: cloudformation_client) }
  let(:poll_stack_delete) { instance_double(PollStackStatus) }
  let(:stdout) { instance_double(IO) }
  let(:options) { {stdout: stdout} }

  let(:stack_name) { 'my_stack_name' }

  before(:each) do
    allow(cloudformation_client).to receive(:delete_stack)
    allow(PollStackStatus).to receive(:new).with(config, stack_name, options).and_return(poll_stack_delete)
    allow(poll_stack_delete).to receive(:execute)
    allow(stdout).to receive(:puts)
  end

  after(:each) do
    AwsHelpers::Actions::CloudFormation::StackDelete.new(config, stack_name, stdout: stdout).execute
  end

  it 'should call delete_stack to remove the stack' do
    expect(cloudformation_client).to receive(:delete_stack).with(stack_name: stack_name)
  end

  it 'should poll for stack delete completion' do
    expect(poll_stack_delete).to receive(:execute)
  end

  it 'should get output stating the stack was deleted' do
    expect(stdout).to receive(:puts).with('Deleting my_stack_name')
  end

end