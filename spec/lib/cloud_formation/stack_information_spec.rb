require 'rspec'
require 'aws_helpers/cloud_formation/client'
require 'aws_helpers/cloud_formation/stack_information'

describe AwsHelpers::CloudFormation::StackInformation do

  let(:stack_name) { 'my_stack_name' }
  let(:options) { {stub_responses: true, endpoint: 'http://endpoint'} }

  let(:config) { double(aws_cloud_formation_client: double, aws_s3_client: double) }
  let(:stack_information) { double(AwsHelpers::CloudFormation::StackInformation) }

  context 'return stack output' do

    it '#stack_information' do

      info_field = 'output'

      allow(AwsHelpers::CloudFormation::Config).to receive(:new).with(options).and_return(config)
      allow(AwsHelpers::CloudFormation::StackInformation).to receive(:new).with(config, stack_name, info_field).and_return(stack_information)
      expect(stack_information).to receive(:execute)
      AwsHelpers::CloudFormation::Client.new(options).stack_information(stack_name, info_field)

    end

  end

  context 'return stack parameters' do

    it '#stack_information' do

      info_field = 'parameters'

      allow(AwsHelpers::CloudFormation::Config).to receive(:new).with(options).and_return(config)
      allow(AwsHelpers::CloudFormation::StackInformation).to receive(:new).with(config, stack_name, info_field).and_return(stack_information)
      expect(stack_information).to receive(:execute)
      AwsHelpers::CloudFormation::Client.new(options).stack_information(stack_name, info_field)

    end

  end

end