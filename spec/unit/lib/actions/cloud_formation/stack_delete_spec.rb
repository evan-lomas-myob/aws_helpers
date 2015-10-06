require 'aws_helpers/cloud_formation'
require 'aws_helpers/actions/cloud_formation/stack_delete'

include AwsHelpers
include AwsHelpers::Actions::CloudFormation

describe StackDelete do

  let(:cloudformation_client) { instance_double(Aws::CloudFormation::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_cloud_formation_client: cloudformation_client) }
  let(:stdout) { instance_double(IO) }

  let(:stack_name) { 'my_stack_name' }

  before(:each) do
    allow(cloudformation_client).to receive(:delete_stack).with(stack_name: stack_name)
    allow(cloudformation_client).to receive(:wait_until).with(anything, stack_name: stack_name)
    allow(stdout).to receive(:puts).with('Deleted my_stack_name')
  end

  after(:each) do
    AwsHelpers::Actions::CloudFormation::StackDelete.new(config, stack_name, stdout).execute
  end

  it 'should call delete_stack to remove the stack' do
    expect(cloudformation_client).to receive(:delete_stack).with(stack_name: stack_name)
  end

  it 'should wait until delete stack is completed' do
    expect(cloudformation_client).to receive(:wait_until).with(anything, stack_name: stack_name)
  end

  it 'should get output stating the stack was deleted' do
    expect(stdout).to receive(:puts).with('Deleted my_stack_name')
  end

end