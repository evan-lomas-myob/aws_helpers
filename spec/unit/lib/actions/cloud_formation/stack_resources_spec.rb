require 'aws_helpers/cloud_formation'
require 'aws_helpers/actions/cloud_formation/stack_resources'

include AwsHelpers
include AwsHelpers::Actions::CloudFormation
include Aws::CloudFormation::Types

describe StackResources do
  let(:cloudformation_client) { instance_double(Aws::CloudFormation::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_cloud_formation_client: cloudformation_client) }

  let(:stack_name) { 'my_stack_name' }

  let(:logical_resource_id) { 'logical_resource_id' }
  let(:physical_resource_id) { 'physical_resource_id' }
  let(:resource_type) { 'AWS::EC2::Instance' }

  let(:stack_resources) do
    instance_double(StackResource,
                    logical_resource_id: logical_resource_id,
                    physical_resource_id: physical_resource_id,
                    resource_type: resource_type)
  end

  let(:response) { instance_double(DescribeStackResourcesOutput, stack_resources: [stack_resources]) }

  it 'should return stack resources' do
    allow(cloudformation_client).to receive(:describe_stack_resources).with(stack_name: stack_name).and_return(response)
    expect(StackResources.new(config, stack_name).execute).to eq([stack_resources])
  end
end
