require 'aws_helpers/cloud_formation'
require 'aws_helpers/actions/cloud_formation/stack_named_resource'

include AwsHelpers
include AwsHelpers::Actions::CloudFormation
include Aws::CloudFormation::Types

describe StackNamedResource do
  let(:cloudformation_client) { instance_double(Aws::CloudFormation::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_cloud_formation_client: cloudformation_client) }

  let(:stack_name) { 'my_stack_name' }

  let(:logical_resource_id) { 'logical_resource_id' }
  let(:physical_resource_id) { 'physical_resource_id' }
  let(:resource_type) { 'AWS::EC2::Instance' }

  let(:stack_resource_detail) do
    instance_double(StackResourceDetail,
                    logical_resource_id: logical_resource_id,
                    physical_resource_id: physical_resource_id,
                    resource_type: resource_type)
  end

  let(:response) { instance_double(DescribeStackResourceOutput, stack_resource_detail: stack_resource_detail) }

  it 'should return a single stack resource' do
    allow(cloudformation_client).to receive(:describe_stack_resource).with(stack_name: stack_name, logical_resource_id: logical_resource_id).and_return(response)
    expect(StackNamedResource.new(config, stack_name, logical_resource_id).execute).to eq(stack_resource_detail)
  end
end
