require 'rspec'
require 'aws_helpers/cloud_formation'
require 'aws_helpers/cloud_formation_actions/stack_provision'

describe AwsHelpers::CloudFormationActions::StackProvision do

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
  let(:stack_provision) { double(AwsHelpers::CloudFormationActions::StackProvision) }

  it 'calls #stack_provision with arguments' do
    expect(AwsHelpers::CloudFormationActions::StackProvision.new(config, stack_name, template, default_parameters,default_capabilities,default_bucket_name,default_bucket_encrypt)).to be
  end

  it '#stack_provision with no options' do

    allow(AwsHelpers::Config).to receive(:new).with(options).and_return(config)
    allow(AwsHelpers::CloudFormationActions::StackProvision).to receive(:new).with(
                                                             config,
                                                             stack_name,
                                                             template,
                                                             default_parameters,
                                                             default_capabilities,
                                                             default_bucket_name,
                                                             default_bucket_encrypt).and_return(stack_provision)
    expect(stack_provision).to receive(:execute)
    AwsHelpers::CloudFormation.new(options).stack_provision(
        stack_name: stack_name,
        template: template)

  end

  it '#stack_provision with additional options' do

    allow(AwsHelpers::Config).to receive(:new).with(options).and_return(config)
    allow(AwsHelpers::CloudFormationActions::StackProvision).to receive(:new).with(
                                                             config,
                                                             stack_name,
                                                             template,
                                                             parameters,
                                                             capabilities,
                                                             bucket_name,
                                                             bucket_encrypt).and_return(stack_provision)
    expect(stack_provision).to receive(:execute)
    AwsHelpers::CloudFormation.new(options).stack_provision(
        stack_name: stack_name,
        template: template,
        parameters: parameters,
        capabilities: capabilities,
        bucket_name: bucket_name,
        bucket_encrypt: bucket_encrypt)

  end

end