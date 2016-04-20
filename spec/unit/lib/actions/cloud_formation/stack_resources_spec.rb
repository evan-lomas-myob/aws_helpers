require 'aws_helpers'

describe AwsHelpers::Actions::CloudFormation::StackResources do
  let(:cloudformation_client) { instance_double(Aws::CloudFormation::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_cloud_formation_client: cloudformation_client) }

  let(:stack_name) { 'name' }
  let(:response) { Aws::CloudFormation::Types::DescribeStackResourcesOutput.new(
      stack_resources: [Aws::CloudFormation::Types::StackResource.new])
  }

  it 'should return stack resources' do
    allow(cloudformation_client).to receive(:describe_stack_resources).with(stack_name: stack_name).and_return(response)
    expect(described_class.new(config, stack_name).execute).to eq(response.stack_resources)
  end
end
