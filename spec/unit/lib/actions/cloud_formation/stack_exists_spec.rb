require 'aws-sdk-core'
require 'aws_helpers'

describe AwsHelpers::Actions::CloudFormation::StackExists do
  let(:cloud_formation_client) { instance_double(Aws::CloudFormation::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_cloud_formation_client: cloud_formation_client) }

  let(:stack_name) { 'my_stack_name' }
  let(:validation_error_stack_not_exists) { Aws::CloudFormation::Errors::ValidationError.new(nil, "Stack with id #{stack_name} does not exist") }
  let(:validation_error_general) { Aws::CloudFormation::Errors::ValidationError.new(nil, 'Error') }

  subject { described_class.new(config, stack_name).execute }

  it 'should create a CloudFormation::Stack resource' do
    allow(cloud_formation_client).to receive(:describe_stacks).with(stack_name: stack_name)
    expect(subject).to eq(true)
  end

  it 'should raise an exception if stack does not exists and return false' do
    allow(cloud_formation_client).to receive(:describe_stacks).with(stack_name: stack_name).and_raise(validation_error_stack_not_exists)
    expect(subject).to eq(false)
  end

  it 'any other exception gets raised' do
    allow(cloud_formation_client).to receive(:describe_stacks).with(stack_name: stack_name).and_raise(validation_error_general)
    expect { subject }.to raise_error(validation_error_general)
  end
end
