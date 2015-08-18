require 'aws-sdk-core'
require 'aws-sdk-resources'
require 'aws_helpers/actions/cloud_formation/stack_provision'
require 'aws_helpers/actions/cloud_formation/stack_delete'
require 'aws_helpers/actions/cloud_formation/stack_exists'

describe AwsHelpers::CloudFormation do

  config = AwsHelpers::Config.new({})
  stack_name = 'cloudformation-test-stack'

  parameters_to_create = [
      {parameter_key: 'MinSize', parameter_value: '0'},
      {parameter_key: 'MaxSize', parameter_value: '1'}
  ]

  capabilities = ['CAPABILITY_IAM']

  before(:each) do
    create_stack(config, stack_name, parameters_to_create, capabilities)
  end

  after(:each) do
    AwsHelpers::Actions::CloudFormation::StackDelete.new(config, stack_name, $stdout).execute
  end

  describe '#stack_exists?' do

    it 'should check if the stack exists once it is created' do
      expect(exists?(config, stack_name)).to eq(true)
    end

  end

  private

  def create_stack(config, stack_name, parameters, capabilities)
    template_json = IO.read(File.join(File.dirname(__FILE__), 'fixtures', 'cloudformation.template.json'))
    AwsHelpers::Actions::CloudFormation::StackProvision.new(config, stack_name, template_json, parameters, capabilities, nil, nil).execute
  end

  def exists?(config, stack_name)
    AwsHelpers::Actions::CloudFormation::StackExists.new(config, stack_name).execute
  end


end
