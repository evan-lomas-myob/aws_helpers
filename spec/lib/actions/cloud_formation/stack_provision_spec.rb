require 'aws_helpers/cloud_formation'
require 'aws_helpers/actions/cloud_formation/stack_provision'

include AwsHelpers
include AwsHelpers::Actions::CloudFormation

describe StackProvision do

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

  let(:options) { { stub_responses: true, endpoint: 'http://endpoint' } }

  let(:config) { double(aws_cloud_formation_client: double, aws_s3_client: double) }
  let(:stack_provision) { double(StackProvision) }

  it 'calls #stack_provision with arguments' do
    expect(StackProvision.new(config, stack_name, template, default_parameters, default_capabilities, default_bucket_name, default_bucket_encrypt)).to be
  end

  it '#stack_provision with no options' do

    allow(Config).to receive(:new).with(options).and_return(config)
    allow(StackProvision).to receive(:new).with(
                               config,
                               stack_name,
                               template,
                               default_parameters,
                               default_capabilities,
                               default_bucket_name,
                               default_bucket_encrypt).and_return(stack_provision)
    expect(stack_provision).to receive(:execute)
    CloudFormation.new(options).stack_provision(
      stack_name: stack_name,
      template: template)

  end

  it '#stack_provision with additional options' do

    allow(Config).to receive(:new).with(options).and_return(config)
    allow(StackProvision).to receive(:new).with(
                               config,
                               stack_name,
                               template,
                               parameters,
                               capabilities,
                               bucket_name,
                               bucket_encrypt).and_return(stack_provision)
    expect(stack_provision).to receive(:execute)
    CloudFormation.new(options).stack_provision(
      stack_name: stack_name,
      template: template,
      parameters: parameters,
      capabilities: capabilities,
      bucket_name: bucket_name,
      bucket_encrypt: bucket_encrypt)

  end

end