require 'aws_helpers/cloud_formation'
require 'aws_helpers/actions/cloud_formation/stack_information'
require 'aws_helpers/actions/cloud_formation/stack_parameter_update_builder'
require 'aws_helpers/actions/cloud_formation/stack_modify_parameters'
require 'aws_helpers/actions/cloud_formation/poll_stack_update'

include Aws::CloudFormation::Types
include AwsHelpers
include AwsHelpers::Actions::CloudFormation

describe StackModifyParameters do

  let(:cloudformation_client) { instance_double(Aws::CloudFormation::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_cloud_formation_client: cloudformation_client) }
  let(:stdout) { instance_double(IO) }

  let(:stack_name) { 'my_stack_name' }

  let(:stack_information) { instance_double(StackInformation) }
  let(:stack_parameter_update_builder) { instance_double(StackParameterUpdateBuilder) }
  let(:poll_stack_update) { instance_double(PollStackUpdate) }

  let(:parameters_to_update) { [
      {parameter_key: 'param_key_1', parameter_value: 'param_value_1'},
      {parameter_key: 'param_key_2', parameter_value: 'new_param_value_2'}
  ] }

  let(:existing_parameters) { [
      Parameter.new(parameter_key: 'param_key_1', parameter_value: 'param_value_1', use_previous_value: true),
      Parameter.new(parameter_key: 'param_key_2', parameter_value: 'param_value_1', use_previous_value: true)
  ] }

  let(:updated_parameters) { [
      {parameter_key: 'param_key_1', use_previous_value: true},
      {parameter_key: 'param_key_2', parameter_value: 'new_param_value_2'}
  ] }

  let(:stack_existing) { [
    Stack.new(stack_name: stack_name, parameters: existing_parameters, capabilities: ['CAPABILITY_IAM'] )
   ] }

  let(:stack_updated) {
      {stack_name: stack_name, use_previous_template: true, parameters: updated_parameters, capabilities: ['CAPABILITY_IAM']}
   }

  let(:response) { instance_double(DescribeStacksOutput, stacks: stack_existing) }

  it 'should call describe stack to get the current stack parameters' do
    expect(cloudformation_client).to receive(:describe_stacks).with(stack_name: stack_name).and_return(response)
    allow(cloudformation_client).to receive(:update_stack).with(stack_updated)
    allow(PollStackUpdate).to receive(:new).with(stdout, config, stack_name, 60).and_return(poll_stack_update)
    allow(poll_stack_update).to receive(:execute)
    StackModifyParameters.new(stdout, config, stack_name, parameters_to_update).execute
  end

  it 'should build the request for the stack update' do
    allow(cloudformation_client).to receive(:describe_stacks).with(stack_name: stack_name).and_return(response)
    allow(cloudformation_client).to receive(:update_stack).with(stack_updated)
    allow(PollStackUpdate).to receive(:new).with(stdout, config, stack_name, 60).and_return(poll_stack_update)
    allow(poll_stack_update).to receive(:execute)
    expect(StackParameterUpdateBuilder.new(stack_name, stack_existing[0], parameters_to_update).execute).to eq(stack_updated)
  end

  it 'should call the update_stack method to start the stack update process' do
    allow(cloudformation_client).to receive(:describe_stacks).with(stack_name: stack_name).and_return(response)
    expect(cloudformation_client).to receive(:update_stack).with(stack_updated)
    allow(PollStackUpdate).to receive(:new).with(stdout, config, stack_name, 60).and_return(poll_stack_update)
    allow(poll_stack_update).to receive(:execute)
    StackModifyParameters.new(stdout, config, stack_name, parameters_to_update).execute
  end

  it 'should call update_stack using the request generated' do
    allow(cloudformation_client).to receive(:describe_stacks).with(stack_name: stack_name).and_return(response)
    allow(cloudformation_client).to receive(:update_stack).with(stack_updated)
    allow(PollStackUpdate).to receive(:new).with(stdout, config, stack_name, 60).and_return(poll_stack_update)
    expect(poll_stack_update).to receive(:execute)
    StackModifyParameters.new(stdout, config, stack_name, parameters_to_update).execute
  end

end