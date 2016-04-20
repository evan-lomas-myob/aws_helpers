require 'aws_helpers'

describe AwsHelpers::Actions::CloudFormation::StackNamedResource do

  let(:cloudformation_client) { instance_double(Aws::CloudFormation::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_cloud_formation_client: cloudformation_client) }

  describe '#execute' do

    let(:stack_name) { 'name' }
    let(:logical_resource_id) { 'logical_resource_id' }
    let(:stack_resource_detail) {
      Aws::CloudFormation::Types::StackResourceDetail.new(
          logical_resource_id: logical_resource_id,
          physical_resource_id: 'physical_resource_id',
          resource_type: 'AWS::EC2::Instance')
    }
    let(:response) { Aws::CloudFormation::Types::DescribeStackResourceOutput.new(
        stack_resource_detail: stack_resource_detail) }

    it 'should return a single stack resource' do
      allow(cloudformation_client).to receive(:describe_stack_resource).with(stack_name: stack_name, logical_resource_id: logical_resource_id).and_return(response)
      expect(described_class.new(config, stack_name, logical_resource_id).execute).to eq(stack_resource_detail)
    end

  end
end
