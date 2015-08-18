require 'aws-sdk-core'
require 'aws-sdk-resources'
require 'aws_helpers/actions/cloud_formation/stack_delete'
require 'aws_helpers/actions/cloud_formation/stack_provision'
require 'aws_helpers/actions/cloud_formation/stack_information'
require 'aws_helpers/actions/cloud_formation/stack_modify_parameters'

describe AwsHelpers::CloudFormation do

  config = AwsHelpers::Config.new({})
  stack_name = 'cloudformation-test-stack'

  parameters_to_create = [
      {parameter_key: 'MinSize', parameter_value: '0'},
      {parameter_key: 'MaxSize', parameter_value: '1'}
  ]

  parameters_to_update = [
      {parameter_key: 'MinSize', parameter_value: '0'},
      {parameter_key: 'MaxSize', parameter_value: '2'}
  ]

  parameters_pre_update =

      [
          Aws::CloudFormation::Types::Parameter.new(
              parameter_key: 'MaxSize',
              parameter_value: '1',
              use_previous_value: nil
          ),
          Aws::CloudFormation::Types::Parameter.new(
              parameter_key: 'MinSize',
              parameter_value: '0',
              use_previous_value: nil
          )
      ]

  parameters_post_update =

      [
          Aws::CloudFormation::Types::Parameter.new(
              parameter_key: 'MaxSize',
              parameter_value: '2',
              use_previous_value: nil
          ),
          Aws::CloudFormation::Types::Parameter.new(
              parameter_key: 'MinSize',
              parameter_value: '0',
              use_previous_value: nil
          )
      ]

  capabilities = ['CAPABILITY_IAM']

  before(:each) do
    create_stack(config, stack_name, parameters_to_create, capabilities)
  end

  after(:each) do
    AwsHelpers::Actions::CloudFormation::StackDelete.new(config, stack_name, $stdout).execute
  end

  describe '#Stack_modify_parameters' do

    it 'should retrieve the original parameters, modify, then check the new parameters' do
      info_field = 'parameters'
      expect(AwsHelpers::Actions::CloudFormation::StackInformation.new(config, stack_name, info_field).execute).to eq(parameters_pre_update)
      expect(AwsHelpers::Actions::CloudFormation::StackModifyParameters.new(config, stack_name, parameters_to_update).execute).to be(nil)
      expect(AwsHelpers::Actions::CloudFormation::StackInformation.new(config, stack_name, info_field).execute).to eq(parameters_post_update)
    end

  end

  private

  def create_stack(config, stack_name, parameters, capabilities)
    template_json = IO.read(File.join(File.dirname(__FILE__), 'fixtures', 'cloudformation.template.json'))
    AwsHelpers::Actions::CloudFormation::StackProvision.new(config, stack_name, template_json, parameters, capabilities, nil, nil).execute
  end

end
