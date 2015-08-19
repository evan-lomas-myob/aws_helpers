require 'aws-sdk-core'
require 'aws-sdk-resources'
require 'aws_helpers/cloud_formation'
require 'aws_helpers/actions/cloud_formation/stack_update'

include Aws::CloudFormation::Types
include AwsHelpers
include AwsHelpers::Actions::CloudFormation

describe StackUpdate do

  let(:cloudformation_client) { instance_double(Aws::CloudFormation::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_cloud_formation_client: cloudformation_client) }
  let(:poll_stack_update) { instance_double(PollStackStatus) }
  let(:stack_error_events) { instance_double(StackErrorEvents) }
  let(:check_stack_failure) { instance_double(CheckStackFailure) }
  let(:stdout) { instance_double(IO) }
  let(:options) { {stdout: stdout} }

  let(:validation_error_no_update) { Aws::CloudFormation::Errors::ValidationError.new(config, 'No updates are to be performed.') }
  let(:validation_error_general) { Aws::CloudFormation::Errors::ValidationError.new(config, 'General Error') }

  let(:stack_name) { 'my_stack_name' }
  let(:url) { 'https://my-bucket-url' }
  let(:parameters) { [
      Parameter.new(parameter_key: 'param_key_1', parameter_value: 'param_value_1'),
      Parameter.new(parameter_key: 'param_key_2', parameter_value: 'param_value_1')
  ] }
  let(:capabilities) { ["CAPABILITY_IAM"] }


  let(:request) { {stack_name: stack_name,
                   s3_template_url: url,
                   parameters: parameters,
                   capabilities: capabilities
  } }

  let(:max_attempts) { 10 }
  let(:delay) { 30 }

  before(:each) do
    allow(cloudformation_client).to receive(:update_stack).with(request)
    allow(cloudformation_client).to receive(:describe_stacks).with(stack_name)
    allow(stdout).to receive(:puts).and_return(anything)
    allow(PollStackStatus).to receive(:new).with(config, stack_name, options).and_return(poll_stack_update)
    allow(poll_stack_update).to receive(:execute)
    allow(StackErrorEvents).to receive(:new).with(config, stack_name, stdout).and_return(stack_error_events)
    allow(stack_error_events).to receive(:execute)
    allow(CheckStackFailure).to receive(:new).with(config, stack_name).and_return(check_stack_failure)
    allow(check_stack_failure).to receive(:execute)
  end

  context 'Update Stack Succeeds' do

    after(:each) do
      AwsHelpers::Actions::CloudFormation::StackUpdate.new(config, stack_name, request, options).execute
    end

    it 'should call update_stack to update the stack' do
      expect(cloudformation_client).to receive(:update_stack).with(request)
    end

    it 'should poll for stack update completion' do
      expect(poll_stack_update).to receive(:execute)
    end

    it 'should check for error events' do
      expect(stack_error_events).to receive(:execute)
    end

    it 'should check for stack update failure' do
      expect(check_stack_failure).to receive(:execute)
    end

    it 'should raise an exception if not updates are required' do
      allow(cloudformation_client).to receive(:update_stack).and_raise(validation_error_no_update)
      expect(stdout).to receive(:puts).and_return("No updates to perform for #{stack_name}.")
    end

  end

  context 'Update Stack Fails' do

    it 'should raise a general exception if validation fails' do
      allow(cloudformation_client).to receive(:update_stack).and_raise(validation_error_general)
      expect { AwsHelpers::Actions::CloudFormation::StackUpdate.new(config, stack_name, request, options).execute }.to raise_error(validation_error_general)
    end

  end

end