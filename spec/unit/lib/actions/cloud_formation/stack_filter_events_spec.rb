require 'aws_helpers/cloud_formation'
require 'aws_helpers/actions/cloud_formation/stack_filter_events'

include Aws::CloudFormation::Types
include AwsHelpers
include AwsHelpers::Actions::CloudFormation

describe StackFilterEvents do

  let(:cloudformation_client) { instance_double(Aws::CloudFormation::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_cloud_formation_client: cloudformation_client) }

  let(:stack_name) { 'my_stack_name' }

  let(:next_token_start) { nil }  #starts here
  let(:next_token_continue) { 'token_string' }  #continues here

  let(:events) { instance_double(StackEvent, )}
  let(:describe_stack_events) { instance_double(DescribeStackEventsOutput, next_token: next_token_start, stack_events: events ) }

  it 'should get stack events' do
    allow(cloudformation_client).to receive(:describe_stack_events).with(stack_name: stack_name, next_token: next_token_start).and_return(describe_stack_events)
    # expect()
    StackFilterEvents.new(config, stack_name)

  end
end