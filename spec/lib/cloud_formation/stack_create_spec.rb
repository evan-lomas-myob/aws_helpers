require 'rspec'
require 'aws_helpers/cloud_formation/client'
require 'aws_helpers/cloud_formation/stack_provision'

describe AwsHelpers::CloudFormation::StackProvision do

  let(:stack_name) { 'my_stack_name' }
  let(:template) { 'my_stack_template' }

  let(:default_parameters) { nil }
  let(:default_capabilities) { nil }
  let(:default_bucket_name) { nil }
  let(:default_bucket_encrypt) { false }


  let(:parameters) { 'my_stack_parameters' }
  let(:capabilities) { 'my_capabilities' }
  let(:bucket_name) { 'my_bucket_name' }
  let(:bucket_encrypt) { true }

  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }

  let(:config) { double(aws_cloud_formation_client: double, aws_s3_client: double) }
  let(:stack_create) { double(AwsHelpers::CloudFormation::StackProvision) }

  it '#stack_create with no options' do

    allow(AwsHelpers::CloudFormation::Config).to receive(:new).with(options).and_return(config)
    allow(AwsHelpers::CloudFormation::StackProvision).to receive(:new).with(
                                                             config,
                                                             stack_name,
                                                             template,
                                                             default_parameters,
                                                             default_capabilities,
                                                             default_bucket_name,
                                                             default_bucket_encrypt).and_return(stack_create)
    expect(stack_create).to receive(:execute)
    AwsHelpers::CloudFormation::Client.new(options).stack_create(
        stack_name: stack_name,
        template: template)

  end

  it '#stack_create with additional options' do

    allow(AwsHelpers::CloudFormation::Config).to receive(:new).with(options).and_return(config)
    allow(AwsHelpers::CloudFormation::StackProvision).to receive(:new).with(
                                                             config,
                                                             stack_name,
                                                             template,
                                                             parameters,
                                                             capabilities,
                                                             bucket_name,
                                                             bucket_encrypt).and_return(stack_create)
    expect(stack_create).to receive(:execute)
    AwsHelpers::CloudFormation::Client.new(options).stack_create(
        stack_name: stack_name,
        template: template,
        parameters: parameters,
        capabilities: capabilities,
        bucket_name: bucket_name,
        bucket_encrypt: bucket_encrypt)

  end

end