require 'aws_helpers/cloud_formation'
require 'aws_helpers/actions/cloud_formation/stack_delete'

include AwsHelpers
include AwsHelpers::Actions::CloudFormation

describe StackDelete do

  let(:stack_name) { 'my_stack_name' }
  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }
  let(:config) { double(aws_cloud_formation_client: double, aws_s3_client: double) }
  let(:stack_delete) { double(StackDelete) }

  it 'calls #stack_delete with arguments' do
    expect(StackDelete.new(config, stack_name)).to be
  end

  it '#stack_delete' do
    allow(Config).to receive(:new).with(options).and_return(config)
    allow(StackDelete).to receive(:new).with(config, stack_name).and_return(stack_delete)
    expect(stack_delete).to receive(:execute)
    CloudFormation.new(options).stack_delete(stack_name: stack_name)
  end

end