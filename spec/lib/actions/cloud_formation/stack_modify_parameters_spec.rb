require 'aws_helpers/cloud_formation'
require 'aws_helpers/actions/cloud_formation/stack_modify_parameters'

include AwsHelpers
include AwsHelpers::Actions::CloudFormation

describe StackModifyParameters do

  let(:stack_name) { 'my_stack_name' }
  let(:parameters) { %w('parameter1','parameter2') }
  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }
  let(:config) { double(aws_cloud_formation_client: double, aws_s3_client: double) }
  let(:stack_modify_parameters) { double(StackModifyParameters) }

  it 'calls #stack_modify_parameters with arguments' do
    expect(StackModifyParameters.new(config, stack_name, parameters)).to be
  end

  it '#stack_modify_parameters' do
    allow(Config).to receive(:new).with(options).and_return(config)
    allow(StackModifyParameters).to receive(:new).with(config, stack_name, parameters).and_return(stack_modify_parameters)
    expect(stack_modify_parameters).to receive(:execute)
    CloudFormation.new(options).stack_modify_parameters(stack_name: stack_name, parameters: parameters)
  end

end