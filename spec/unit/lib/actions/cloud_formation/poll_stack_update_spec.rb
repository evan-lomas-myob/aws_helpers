require 'aws_helpers/config'
require 'aws_helpers/actions/cloud_formation/poll_stack_update'

include AwsHelpers::Actions::CloudFormation

describe PollStackUpdate do

  let(:cloudformation_client) { instance_double(Aws::CloudFormation::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_cloud_formation_client: cloudformation_client) }
  let(:stdout) { instance_double(IO) }

  let(:stack_resource) { instance_double(Aws::CloudFormation::Stack) }
  let(:describe_stack_response) { instance_double(DescribeStacksOutput) }
  let(:describe_stack_events_response) { instance_double(DescribeStackEventsOutput) }

  let(:stdout) { instance_double(IO) }
  let(:stack_name) { 'my_stack_name' }
  let(:response) { double(stack_status: 'UPDATE_COMPLETE') }

  let(:max_attempts) { 1 }
  let(:delay) { 1 }
  let(:output) { 'Stack - my_stack_name status UPDATE_COMPLETE' }

  before(:each) do
    allow(Aws::CloudFormation::Stack).to receive(:new).with(stack_name, client: cloudformation_client).and_return(stack_resource)
    allow(stack_resource).to receive(:wait_until).with(max_attempts: 1, delay: 1)
  end

  after(:each) do
    PollStackUpdate.new(config, stack_name, max_attempts, delay, stdout).execute
  end

  describe '#execute' do

    it 'should create Stack resource' do
      expect(Aws::CloudFormation::Stack).to receive(:new).with(stack_name, client: cloudformation_client).and_return(stack_resource)
    end

    it 'should call wait_until method on the Stack resource' do
      expect(stack_resource).to receive(:wait_until).with(max_attempts: 1, delay: 1)
    end

  end
end