require 'aws_helpers'
require_relative '../../../spec_helpers/create_event_helper'

describe AwsHelpers::Actions::CloudFormation::StackRetrieveEvents do
  let(:cloudformation_client) { instance_double(Aws::CloudFormation::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_cloud_formation_client: cloudformation_client) }
  let(:stack_resource) { instance_double(Aws::CloudFormation::Stack) }

  let(:stack_name) { 'my_stack_name' }
  let(:stack_id) { 'id' }
  let(:resource_type) { 'AWS::CloudFormation::Stack' }

  let(:initiation_event) { CreateEventHelper.new(stack_name, stack_id, 'CREATE_IN_PROGRESS', resource_type).execute }
  let(:failed_event) { CreateEventHelper.new(stack_name, stack_id, 'CREATE_FAILED', resource_type).execute }
  let(:complete_event) { CreateEventHelper.new(stack_name, stack_id, 'DELETE_COMPLETE', resource_type).execute }

  let(:stack_events) { [initiation_event, failed_event, complete_event] }

  let(:describe_stack_events_output) { instance_double(Aws::CloudFormation::Types::DescribeStackEventsOutput, stack_events: stack_events, next_token: nil) }

  describe '#execute' do
    it 'should call describe_stack_events to get events' do
      expect(cloudformation_client).to receive(:describe_stack_events).with(stack_name: stack_id, next_token: nil).and_return(describe_stack_events_output)
      AwsHelpers::Actions::CloudFormation::StackRetrieveEvents.new(config, stack_id).execute
    end

    it 'should call execute and return events' do
      allow(cloudformation_client).to receive(:describe_stack_events).with(stack_name: stack_id, next_token: nil).and_return(describe_stack_events_output)
      expect(AwsHelpers::Actions::CloudFormation::StackRetrieveEvents.new(config, stack_id).execute).to eq(stack_events)
    end
  end
end
