require 'aws_helpers/cloud_formation'
require 'aws_helpers/actions/cloud_formation/stack_exists'

include AwsHelpers
include AwsHelpers::Actions::CloudFormation

describe StackExists do

  let(:stack_name) { 'my_stack_name' }
  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }
  let(:config) { double(aws_cloud_formation_client: double, aws_s3_client: double) }
  let(:stack_exists) { double(StackExists) }

  it 'calls #stack_exists with arguments' do
    expect(StackExists.new(config, stack_name)).to be
  end

  it '#stack_exists' do
    allow(Config).to receive(:new).with(options).and_return(config)
    allow(StackExists).to receive(:new).with(config, stack_name).and_return(stack_exists)
    expect(stack_exists).to receive(:execute)
    CloudFormation.new(options).stack_exists?(stack_name: stack_name)
  end

end