require 'rspec'
require 'aws_helpers/cloud_formation/client'
require 'aws_helpers/cloud_formation/stack_exists'

describe AwsHelpers::CloudFormation::StackExists do

  let(:stack_name) { 'my_stack_name' }
  
  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }

  let(:config) { double(aws_cloud_formation_client: double, aws_s3_client: double) }
  let(:stack_exists) { double(AwsHelpers::CloudFormation::StackExists) }

  it '#stack_exists' do

    allow(AwsHelpers::CloudFormation::Config).to receive(:new).with(options).and_return(config)
    allow(AwsHelpers::CloudFormation::StackExists).to receive(:new).with(config, stack_name).and_return(stack_exists)
    expect(stack_exists).to receive(:execute)
    AwsHelpers::CloudFormation::Client.new(options).stack_exists?(stack_name: stack_name)

  end

end