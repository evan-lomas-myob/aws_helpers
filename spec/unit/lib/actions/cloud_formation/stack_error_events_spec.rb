require_relative '../../../spec_helpers/create_event_helper'
require 'aws_helpers'

describe AwsHelpers::Actions::CloudFormation::StackErrorEvents do

  describe '#execute' do

    let(:cloudformation_client) { instance_double(Aws::CloudFormation::Client) }
    let(:config) { instance_double(AwsHelpers::Config, aws_cloud_formation_client: cloudformation_client) }
    let(:stdout) { instance_double(IO) }
    let(:stack_retrieve_events) { instance_double(AwsHelpers::Actions::CloudFormation::StackRetrieveEvents) }
    let(:stack_events_filter_post_initiation) { instance_double(AwsHelpers::Actions::CloudFormation::StackEventsFilterPostInitiation) }
    let(:stack_events_filter_failed) { instance_double(AwsHelpers::Actions::CloudFormation::StackEventsFilterFailed) }

    let(:stack_id) { 'id' }
    let(:options) { {stdout: stdout, delay: 1, max_retries: 2} }

    let(:stack_events) { [CreateEventHelper.new(stack_id, 'name', 'DELETE_COMPLETE', 'AWS::CloudFormation::Stack').execute] }
    let(:describe_stack_events_output) {
      Aws::CloudFormation::Types::DescribeStackEventsOutput.new(
          stack_events: stack_events,
          next_token: nil)
    }

    before(:each) do
      allow(cloudformation_client).to receive(:describe_stack_events).and_return(describe_stack_events_output)
      allow(AwsHelpers::Actions::CloudFormation::StackRetrieveEvents).to receive(:new).and_return(stack_retrieve_events)
      allow(stack_retrieve_events).to receive(:execute).and_return(stack_events)
      allow(AwsHelpers::Actions::CloudFormation::StackEventsFilterPostInitiation).to receive(:new).and_return(stack_events_filter_post_initiation)
      allow(stack_events_filter_post_initiation).to receive(:execute).and_return(stack_events)
      allow(AwsHelpers::Actions::CloudFormation::StackEventsFilterFailed).to receive(:new).and_return(stack_events_filter_failed)
      allow(stack_events_filter_failed).to receive(:execute).and_return(stack_events)
      allow(stdout).to receive(:puts)
    end

    after(:each) do
      described_class.new(config, stack_id, options).execute
    end

    it 'should call AwsHelpers::Actions::CloudFormation::StackRetrieveEvents #new with correct parameters' do
      expect(AwsHelpers::Actions::CloudFormation::StackRetrieveEvents).to receive(:new).with(config, stack_id)
    end

    it 'should call AwsHelpers::Actions::CloudFormation::StackRetrieveEvents #execute' do
      expect(stack_retrieve_events).to receive(:execute)
    end

    it 'should call AwsHelpers::Actions::CloudFormation::StackEventsFilterPostInitiation #new with the stack_events' do
      expect(AwsHelpers::Actions::CloudFormation::StackEventsFilterPostInitiation).to receive(:new).with(stack_events)
    end

    it 'should call AwsHelpers::Actions::CloudFormation::StackEventsFilterPostInitiation #execute' do
      expect(stack_events_filter_post_initiation).to receive(:execute)
    end

    it 'should call AwsHelpers::Actions::CloudFormation::StackEventsFilterFailed #new with the stack_events' do
      expect(AwsHelpers::Actions::CloudFormation::StackEventsFilterFailed).to receive(:new).with(stack_events)
    end

    it 'should call AwsHelpers::Actions::CloudFormation::StackEventsFilterFailed #execute' do
      expect(stack_events_filter_failed).to receive(:execute)
    end

    it 'should call stdout #puts with event information' do
      expect(stdout).to receive(:puts).with("#{Time.parse('01-Jan-2015 00:00:00')}, DELETE_COMPLETE, ResourceID, Success/failure message")
    end

  end
end
