require 'aws_helpers/cloud_formation'
require 'aws_helpers/actions/cloud_formation/stack_information'

describe AwsHelpers::CloudFormationActions::StackInformation do

  let(:stack_name) { 'my_stack_name' }
  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }
  let(:config) { double(aws_cloud_formation_client: double, aws_s3_client: double) }
  let(:stack_information) { double(AwsHelpers::CloudFormationActions::StackInformation) }

  it 'calls #stack_information with arguments' do
    expect(AwsHelpers::CloudFormationActions::StackInformation.new(config, stack_name, 'output')).to be
  end

  context 'return stack output' do

    it '#stack_information' do
      info_field = 'output'
      allow(AwsHelpers::Config).to receive(:new).with(options).and_return(config)
      allow(AwsHelpers::CloudFormationActions::StackInformation).to receive(:new).with(config, stack_name, info_field).and_return(stack_information)
      expect(stack_information).to receive(:execute)
      AwsHelpers::CloudFormation.new(options).stack_information(stack_name: stack_name, info_field: info_field)

    end

  end

  context 'return stack parameters' do

    it '#stack_information' do
      info_field = 'parameters'
      allow(AwsHelpers::Config).to receive(:new).with(options).and_return(config)
      allow(AwsHelpers::CloudFormationActions::StackInformation).to receive(:new).with(config, stack_name, info_field).and_return(stack_information)
      expect(stack_information).to receive(:execute)
      AwsHelpers::CloudFormation.new(options).stack_information(stack_name: stack_name, info_field: info_field)
    end

  end

end