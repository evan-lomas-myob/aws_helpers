require 'aws_helpers/cloud_formation'
require 'aws_helpers/actions/cloud_formation/stack_delete'

include AwsHelpers
include AwsHelpers::Actions::CloudFormation

describe StackDelete do

  let(:cloudformation_client) { instance_double(Aws::CloudFormation::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_cloud_formation_client: cloudformation_client) }
  let(:stdout) { instance_double(IO) }

  let(:stack_name) { 'my_stack_name'}

  it 'should call delete_stack to remove the stack' do
    allow(cloudformation_client).to receive(:delete_stack).with(stack_name: stack_name)
    allow(cloudformation_client).to receive(:wait_until).with(anything, stack_name: stack_name)
    expect(stdout).to receive(:puts).with('Deleted my_stack_name')
    AwsHelpers::Actions::CloudFormation::StackDelete.new(stdout, config, stack_name).execute
  end

end