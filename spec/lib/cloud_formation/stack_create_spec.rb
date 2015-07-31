require 'rspec'
require 'aws_helpers/cloud_formation/client'
require 'aws_helpers/cloud_formation/stack_create'

describe AwsHelpers::CloudFormation::StackCreate do

  let(:stack_name) { 'my_stack_name' }
  let(:template) { 'my_stack_template' }
  let(:parameters) { 'my_stack_parameters' }
  let(:capabilities) { 'my_capabilities' }
  let(:bucket_name) { 'my_bucket_name' }
  let(:bucket_encrypt) { false }

  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }

  let(:config) { double(aws_cloud_formation_client: double, aws_s3_client: double) }
  let(:stack_create) { double(AwsHelpers::CloudFormation::StackCreate) }

  it '#stack_create' do

    allow(AwsHelpers::CloudFormation::Config).to receive(:new).with(options).and_return(config)
    allow(AwsHelpers::CloudFormation::StackCreate).to receive(:new).with(config, stack_name, template, parameters, capabilities, bucket_name, bucket_encrypt).and_return(stack_create)
    expect(stack_create).to receive(:execute)
    AwsHelpers::CloudFormation::Client.new(options).stack_create(
        stack_name: stack_name, template: template, parameters: parameters, capabilities: capabilities, bucket_name: bucket_name, bucket_encrypt: bucket_encrypt)

  end

end