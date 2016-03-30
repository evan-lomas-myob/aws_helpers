require 'aws_helpers/actions/cloud_formation/stack_events_filter_post_initiation'
require_relative '../../../spec_helpers/create_event_helper'

include AwsHelpers::Actions::CloudFormation

describe StackEventsFilterPostInitiation do
  let(:stack_name) { 'my_stack_name' }
  let(:resource_type) { 'AWS::CloudFormation::Stack' }
  let(:resource_type_bad) { 'AWS::EC2::Instance' }

  let(:create_in_progress_event) { CreateEventHelper.new(stack_name, 'CREATE_IN_PROGRESS', resource_type).execute }
  let(:create_failed_event) { CreateEventHelper.new(stack_name, 'CREATE_FAILED', resource_type).execute }
  let(:rollback_in_progress_event) { CreateEventHelper.new(stack_name, 'ROLLBACK_IN_PROGRESS', resource_type).execute }
  let(:initiation_event) { CreateEventHelper.new(stack_name, 'DELETE_IN_PROGRESS', resource_type).execute }
  let(:complete_event) { CreateEventHelper.new(stack_name, 'DELETE_COMPLETE', resource_type).execute }

  let(:stack_events_initiate) { [create_failed_event, rollback_in_progress_event, initiation_event] }
  let(:stack_events_complete) { [create_failed_event, rollback_in_progress_event, complete_event] }
  let(:stack_events_break_initiate) { [create_failed_event, rollback_in_progress_event, initiation_event, create_in_progress_event] }
  let(:stack_events_break_complete) { [create_failed_event, rollback_in_progress_event, complete_event, create_in_progress_event] }

  describe '#execute' do
    it 'should just return the complete array' do
      expect(AwsHelpers::Actions::CloudFormation::StackEventsFilterPostInitiation.new(stack_events_complete).execute).to eq(stack_events_complete)
    end

    it 'should drop the last event from array stack because the initiate event was found' do
      expect(AwsHelpers::Actions::CloudFormation::StackEventsFilterPostInitiation.new(stack_events_break_initiate).execute).to eq(stack_events_initiate)
    end

    it 'should drop the last event from array stack because the complete event was found' do
      expect(AwsHelpers::Actions::CloudFormation::StackEventsFilterPostInitiation.new(stack_events_break_complete).execute).to eq(stack_events_complete)
    end
  end
end
