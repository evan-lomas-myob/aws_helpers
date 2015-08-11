require 'aws_helpers/cloud_formation'
require 'aws_helpers/actions/cloud_formation/stack_information'

include AwsHelpers
include AwsHelpers::Actions::CloudFormation
include Aws::CloudFormation::Types

describe StackInformation do

  let(:cloudformation_client) { instance_double(Aws::CloudFormation::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_cloud_formation_client: cloudformation_client) }

  let(:stack_name) { 'my_stack_name' }

  let(:parameters) { [
      instance_double(Parameter, parameter_key: 'param_key_1', parameter_value: 'param_value_1'),
      instance_double(Parameter, parameter_key: 'param_key_1', parameter_value: 'param_value_1')
  ] }

  let(:outputs) { [
      instance_double(Output, output_key: 'output_key_1', output_value: 'output_value_1', description: 'output_description_1'),
      instance_double(Output, output_key: 'output_key_2', output_value: 'output_value_2', description: 'output_description_2')
  ] }

  let(:stack_list) { [
      instance_double(Stack, stack_name: stack_name, parameters: parameters, outputs: outputs)
      ] }

  let(:response) { instance_double(DescribeStacksOutput, stacks: stack_list) }

  it 'should return stack parameters' do
    info_field = 'parameters'
    allow(cloudformation_client).to receive(:describe_stacks).with(stack_name: stack_name).and_return(response)
    expect(StackInformation.new(config, stack_name, info_field).execute).to eq(parameters)
  end

  it 'should return stack outputs' do
    info_field = 'outputs'
    allow(cloudformation_client).to receive(:describe_stacks).with(stack_name: stack_name).and_return(response)
    expect(StackInformation.new(config, stack_name, info_field).execute).to eq(outputs)
  end

end