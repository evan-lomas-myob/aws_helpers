require 'aws_helpers'

describe AwsHelpers::CloudFormation do

  stack_name = 'cloudformation-test-stack'

  parameters_to_create = [
      {parameter_key: 'MinSize', parameter_value: '0'},
      {parameter_key: 'MaxSize', parameter_value: '1'}
  ]

  parameters_to_update = [
      {parameter_key: 'MinSize', parameter_value: '0'},
      {parameter_key: 'MaxSize', parameter_value: '2'}
  ]

  parameters_initial =

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
  outputs = ''

  before(:each) do
    outputs = create_stack(stack_name, parameters_to_create, capabilities)
  end

  after(:each) do
    AwsHelpers::CloudFormation.new.stack_delete(stack_name: stack_name)
  end

  describe '#stack_exists?' do

    it 'should check if the stack exists once it is created' do
      expect(AwsHelpers::CloudFormation.new.stack_exists?(stack_name: stack_name)).to eq(true)
    end

  end

  describe '#stack_information' do

    it 'should retrieve the updated parameters' do
      info_field = 'parameters'
      expect(AwsHelpers::CloudFormation.new.stack_information(stack_name: stack_name, info_field: info_field)).to eq(parameters_initial)
    end

    it 'should retrieve the outputs' do
      info_field = 'outputs'
      expect(AwsHelpers::CloudFormation.new.stack_information(stack_name: stack_name, info_field: info_field)).to eq(outputs)
    end

  end

  describe '#stack_modify_parameters' do

    it 'should retrieve the original parameters, modify, then check the new parameters' do
      info_field = 'parameters'
      expect(AwsHelpers::CloudFormation.new.stack_information(stack_name: stack_name, info_field: info_field)).to eq(parameters_initial)
      expect(AwsHelpers::CloudFormation.new.stack_modify_parameters(stack_name: stack_name, parameters: parameters_to_update)).to be(nil)
      expect(AwsHelpers::CloudFormation.new.stack_information(stack_name: stack_name, info_field: info_field)).to eq(parameters_post_update)
    end

  end

  private

  def create_stack(stack_name, parameters, capabilities)

    template_json = IO.read(File.join(File.dirname(__FILE__), 'fixtures', 'cloudformation.template.json'))

    AwsHelpers::CloudFormation.new.stack_provision(
        stack_name: stack_name,
        template: template_json,
        parameters: parameters,
        capabilities: capabilities,
        bucket_name: nil,
        bucket_encrypt: false
    )

  end

end
