require 'aws-sdk-core'
require 'aws-sdk-resources'
require 'aws_helpers/actions/cloud_formation/stack_delete'
require 'aws_helpers/actions/cloud_formation/stack_provision'
require 'aws_helpers/actions/cloud_formation/stack_information'

describe AwsHelpers::CloudFormation do

  config = AwsHelpers::Config.new({})
  stack_name = 'cloudformation-test-stack'

  parameters_to_create = [
      {parameter_key: 'MinSize', parameter_value: '0'},
      {parameter_key: 'MaxSize', parameter_value: '1'}
  ]

 parameters_post_create =

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

  capabilities = ['CAPABILITY_IAM']
  outputs = ''

  before(:each) do
    outputs = create_stack(config, stack_name, parameters_to_create, capabilities)
  end

  after(:each) do
    AwsHelpers::Actions::CloudFormation::StackDelete.new(config, stack_name).execute
  end

  describe '#stack_information' do

    it 'should retrieve the updated parameters' do
      info_field = 'parameters'
      expect(AwsHelpers::Actions::CloudFormation::StackInformation.new(config, stack_name, info_field).execute).to eq(parameters_post_create)
    end

    it 'should retrieve the outputs' do
      info_field = 'outputs'
      expect(AwsHelpers::Actions::CloudFormation::StackInformation.new(config, stack_name, info_field).execute).to eq(outputs)
    end

  end

  private

  def create_stack(config, stack_name, parameters, capabilities)
    template_json = IO.read(File.join(File.dirname(__FILE__), 'fixtures', 'cloudformation.template.json'))
    AwsHelpers::Actions::CloudFormation::StackProvision.new(config, stack_name, template_json, parameters, capabilities, nil, nil).execute
  end

end
