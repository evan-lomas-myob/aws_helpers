require 'rspec'
require 'aws_helpers/cloud_formation'
require 'aws_helpers/cloud_formation_actions/stack_delete'

describe AwsHelpers::CloudFormationActions::StackDelete do

  let(:stack_name) { 'my_stack_name' }
  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }
  let(:config) { double(aws_cloud_formation_client: double, aws_s3_client: double) }
  let(:stack_delete) { double(AwsHelpers::CloudFormationActions::StackDelete) }

  it 'calls #stack_delete with arguments' do
    expect(AwsHelpers::CloudFormationActions::StackDelete.new(config, stack_name)).to be
  end

  it '#stack_delete' do

    allow(AwsHelpers::Config).to receive(:new).with(options).and_return(config)
    allow(AwsHelpers::CloudFormationActions::StackDelete).to receive(:new).with(config, stack_name).and_return(stack_delete)
    expect(stack_delete).to receive(:execute)
    AwsHelpers::CloudFormation.new(options).stack_delete(stack_name: stack_name)

  end

end