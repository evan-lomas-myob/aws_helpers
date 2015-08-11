require 'aws_helpers/cloud_formation'
require 'aws_helpers/actions/cloud_formation/stack_information'
require 'aws_helpers/actions/cloud_formation/stack_parameter_update_builder'
require 'aws_helpers/actions/cloud_formation/stack_modify_parameters'

include Aws::CloudFormation::Types
include AwsHelpers
include AwsHelpers::Actions::CloudFormation

describe StackParameterUpdateBuilder do

  let(:stack_name) { 'my_stack_name' }

  let(:parameters_to_update) { [
      {parameter_key: 'existing_param_key_1', parameter_value: 'existing_param_value'},
      {parameter_key: 'existing_param_key_2', parameter_value: 'new_param_value_2'}
  ] }

  let(:existing_parameters) { [
      {parameter_key: 'existing_param_key_1', parameter_value: 'existing_param_value'},
      {parameter_key: 'existing_param_key_2', parameter_value: 'existing_param_value'}
  ] }

  let(:updated_parameters) { [
      {parameter_key: 'existing_param_key_1', use_previous_value: true},
      {parameter_key: 'existing_param_key_2', parameter_value: 'new_param_value_2'}
  ] }

  let(:stack_existing) { {stack_name: stack_name, parameters: existing_parameters, capabilities: ['CAPABILITY_IAM']} }
  let(:stack_updated) { {stack_name: stack_name, use_previous_template: true, parameters: updated_parameters, capabilities: ['CAPABILITY_IAM']} }

  it 'should call the stack parameter builder and return the updated stack hash' do
    expect(StackParameterUpdateBuilder.new(stack_name, stack_existing, parameters_to_update).execute).to eq(stack_updated)
  end

end