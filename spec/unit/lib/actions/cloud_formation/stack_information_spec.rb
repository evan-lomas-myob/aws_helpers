require 'aws_helpers'

describe AwsHelpers::Actions::CloudFormation::StackInformation do
  let(:cloudformation_client) { instance_double(Aws::CloudFormation::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_cloud_formation_client: cloudformation_client) }

  let(:stack_name) { 'my_stack_name' }
  let(:parameters) { [Aws::CloudFormation::Types::Parameter.new] }
  let(:outputs) { [Aws::CloudFormation::Types::Output.new] }
  let(:response) {
    Aws::CloudFormation::Types::DescribeStacksOutput.new(
        stacks: [
            Aws::CloudFormation::Types::Stack.new(stack_name: stack_name, parameters: parameters, outputs: outputs)
        ])
  }

  describe '#execute' do

    before(:each) do
      allow(cloudformation_client).to receive(:describe_stacks).with(stack_name: stack_name).and_return(response)
    end

    it 'should return stack parameters' do
      expect(described_class.new(config, stack_name, 'parameters').execute).to eq(parameters)
    end

    it 'should return stack outputs' do
      expect(described_class.new(config, stack_name, 'outputs').execute).to eq(outputs)
    end

  end

end
