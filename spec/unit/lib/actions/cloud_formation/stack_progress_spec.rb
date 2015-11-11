require 'aws-sdk-core'
require 'aws-sdk-resources'
require 'aws_helpers/cloud_formation'
require 'aws_helpers/actions/cloud_formation/stack_progress'

include Aws::CloudFormation::Types
include AwsHelpers
include AwsHelpers::Actions::CloudFormation

describe StackProgress do

  let(:cloudformation_client) { instance_double(Aws::CloudFormation::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_cloud_formation_client: cloudformation_client) }

  let(:poll_stack_status) { instance_double(PollStackStatus) }
  let(:stack_error_events) { instance_double(StackErrorEvents) }
  let(:check_stack_failure) { instance_double(CheckStackFailure) }

  let(:stdout) { instance_double(IO) }
  let(:stack_name) { 'my_stack_name' }
  let(:max_attempts) { 10 }
  let(:delay) { 30 }

  let(:options) { {stack_name: stack_name, stdout: stdout, delay: delay, max_attempts: max_attempts} }

  before(:each) do
    allow(PollStackStatus).to receive(:new).with(config, options).and_return(poll_stack_status)
    allow(poll_stack_status).to receive(:execute)
    allow(StackErrorEvents).to receive(:new).with(config, options).and_return(stack_error_events)
    allow(stack_error_events).to receive(:execute)
    allow(CheckStackFailure).to receive(:new).with(config, options).and_return(check_stack_failure)
    allow(check_stack_failure).to receive(:execute)
  end

  after(:each) do
    AwsHelpers::Actions::CloudFormation::StackProgress.new(config,options).execute
  end

  it 'should call PollStackStatus to check the stack action progress' do
    expect(poll_stack_status).to receive(:execute)
  end

  it 'should call StackErrorEvents to check if errors occurred' do
    expect(stack_error_events).to receive(:execute)
  end

  it 'should call CheckStackFailure to check if a failure occurred' do
    expect(check_stack_failure).to receive(:execute)
  end

end