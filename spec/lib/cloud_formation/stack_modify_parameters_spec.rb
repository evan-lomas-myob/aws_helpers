require 'rspec'
require 'aws_helpers/cloud_formation/client'
require 'aws_helpers/cloud_formation/stack_modify_parameters'

describe AwsHelpers::CloudFormation::StackModifyParameters do

  let(:stack_name) { 'my_stack_name' }
  let(:parameters) { %w('parameter1','parameter2') }

  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }

  let(:config) { double(aws_cloud_formation_client: double, aws_s3_client: double) }
  let(:stack_modify_parameters) { double(AwsHelpers::CloudFormation::StackModifyParameters) }

  it '#stack_modify_parameters' do

    allow(AwsHelpers::CloudFormation::Config).to receive(:new).with(options).and_return(config)
    allow(AwsHelpers::CloudFormation::StackModifyParameters).to receive(:new).with(config, stack_name, parameters).and_return(stack_modify_parameters)
    expect(stack_modify_parameters).to receive(:execute)
    AwsHelpers::CloudFormation::Client.new(options).stack_modify_parameters(stack_name: stack_name, parameters: parameters)

  end

end