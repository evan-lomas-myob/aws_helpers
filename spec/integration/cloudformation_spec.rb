require 'aws_helpers'

describe AwsHelpers::CloudFormation do

  stack_name = 'cloudformation-test-stack'

  parameters_to_create = [
    { parameter_key: 'MinSize', parameter_value: '0' },
    { parameter_key: 'MaxSize', parameter_value: '1' }
  ]

  parameters_to_update = [
    { parameter_key: 'MinSize', parameter_value: '0' },
    { parameter_key: 'MaxSize', parameter_value: '2' }
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
    AwsHelpers::CloudFormation.new.stack_delete(stack_name)
  end

  describe '#stack_exists?' do

    it 'should check if the stack exists once it is created' do
      expect(AwsHelpers::CloudFormation.new.stack_exists?(stack_name)).to eq(true)
    end

  end

  describe '#stack_ouputs' do

    it 'should retrieve the outputs' do
      expect(AwsHelpers::CloudFormation.new.stack_outputs(stack_name)).to eq(outputs)
    end

  end

  describe '#stack_parameters' do

    it 'should retrieve the updated parameters' do
      expect(AwsHelpers::CloudFormation.new.stack_parameters(stack_name)).to eq(parameters_initial)
    end

  end

  describe '#stack_modify_parameters' do

    it 'should retrieve the original parameters, modify, then check the new parameters' do
      expect(AwsHelpers::CloudFormation.new.stack_parameters(stack_name)).to eq(parameters_initial)
      expect(AwsHelpers::CloudFormation.new.stack_modify_parameters(stack_name, parameters_to_update)).to be(nil)
      expect(AwsHelpers::CloudFormation.new.stack_parameters(stack_name)).to eq(parameters_post_update)
    end

  end

  private

  def create_stack(stack_name, parameters, capabilities)

    template_json = IO.read(File.join(File.dirname(__FILE__), 'fixtures', 'cloudformation.template.json'))
    AwsHelpers::CloudFormation.new.stack_provision(stack_name, template_json, parameters: parameters, capabilities: capabilities)

  end

end
