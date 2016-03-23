require 'aws-sdk-core'
require 'aws_helpers/cloud_formation'
require 'aws_helpers/actions/cloud_formation/stack_create'

include Aws::CloudFormation::Types
include AwsHelpers
include AwsHelpers::Actions::CloudFormation

describe StackCreate do

  let(:cloudformation_client) { instance_double(Aws::CloudFormation::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_cloud_formation_client: cloudformation_client) }
  let(:stack_progress) { instance_double(StackProgress) }
  let(:stdout) { instance_double(IO) }
  let(:stack_name) { 'my_stack_name' }

  let(:options) { {stack_name: stack_name, stdout: stdout} }
  let(:url) { 'https://my-bucket-url' }
  let(:parameters) { [
      Parameter.new(parameter_key: 'param_key_1', parameter_value: 'param_value_1'),
      Parameter.new(parameter_key: 'param_key_2', parameter_value: 'param_value_1')
  ] }
  let(:capabilities) { ["CAPABILITY_IAM"] }


  let(:request) { {stack_name: stack_name,
                   s3_template_url: url,
                   parameters: parameters,
                   capabilities: capabilities
  } }

  let(:max_attempts) { 10 }
  let(:delay) { 30 }

  before(:each) do
    allow(cloudformation_client).to receive(:create_stack).with(request)
    allow(cloudformation_client).to receive(:describe_stacks).with(stack_name)
    allow(StackProgress).to receive(:new).with(config, options).and_return(stack_progress)
    allow(stack_progress).to receive(:execute)
    allow(stdout).to receive(:puts).and_return(anything)
    AwsHelpers::Actions::CloudFormation::StackCreate.new(config, stack_name, request, options).execute
  end

  after(:each) do
    AwsHelpers::Actions::CloudFormation::StackCreate.new(config, stack_name, request, options).execute
  end

  it 'should call create_stack to update the stack' do
    expect(cloudformation_client).to receive(:create_stack).with(request)
  end

  it 'should poll for stack update completion' do
    expect(stack_progress).to receive(:execute)
  end

end