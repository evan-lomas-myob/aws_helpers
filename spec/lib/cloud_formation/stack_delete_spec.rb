require 'rspec'
require 'aws_helpers/cloud_formation/client'
require 'aws_helpers/cloud_formation/stack_delete'

describe AwsHelpers::CloudFormation::StackDelete do

  let(:stack_name) { 'my_stack_name' }
  
  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }

  let(:config) { double(aws_cloud_formation_client: double, aws_s3_client: double) }
  let(:stack_delete) { double(AwsHelpers::CloudFormation::StackDelete) }

  it 'calls #stack_delete with arguments' do
    expect(AwsHelpers::CloudFormation::StackDelete.new(config, stack_name)).to be
  end

  it '#stack_delete' do

    allow(AwsHelpers::CloudFormation::Config).to receive(:new).with(options).and_return(config)
    allow(AwsHelpers::CloudFormation::StackDelete).to receive(:new).with(config, stack_name).and_return(stack_delete)
    expect(stack_delete).to receive(:execute)
    AwsHelpers::CloudFormation::Client.new(options).stack_delete(stack_name: stack_name)

  end

end