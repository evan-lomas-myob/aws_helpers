require 'aws_helpers/actions/cloud_formation/stack_initiation_event'
require_relative '../../../spec_helpers/create_event_helper'

include AwsHelpers::Actions::CloudFormation

describe StackInitiationEvent do
  let(:stack_id) { 'id' }
  let(:stack_name) { 'my_stack_name' }
  let(:resource_type) { 'AWS::CloudFormation::Stack' }
  let(:resource_type_bad) { 'AWS::EC2::Instance' }

  let(:create_in_progress_event) { CreateEventHelper.new(stack_name, stack_id, 'CREATE_IN_PROGRESS', resource_type).execute }
  let(:update_in_progress_event) { CreateEventHelper.new(stack_name, stack_id, 'UPDATE_IN_PROGRESS', resource_type).execute }
  let(:delete_in_progress_event) { CreateEventHelper.new(stack_name, stack_id, 'DELETE_IN_PROGRESS', resource_type).execute }
  let(:create_in_progress_event_wrong_type) { CreateEventHelper.new(stack_name, stack_id, 'CREATE_IN_PROGRESS', resource_type_bad).execute }
  let(:wrong_event) { CreateEventHelper.new(stack_name, stack_id, 'DELETE_COMPLETE', resource_type).execute }

  describe '#execute' do
    it 'should return true because the event has a matching resource status' do
      expect(AwsHelpers::Actions::CloudFormation::StackInitiationEvent.new(create_in_progress_event).execute).to be(true)
    end

    it 'should return true because the event has a matching resource status' do
      expect(AwsHelpers::Actions::CloudFormation::StackInitiationEvent.new(update_in_progress_event).execute).to be(true)
    end

    it 'should return true because the event has a matching resource status' do
      expect(AwsHelpers::Actions::CloudFormation::StackInitiationEvent.new(delete_in_progress_event).execute).to be(true)
    end

    it 'should return false because the event has the wrong status' do
      expect(AwsHelpers::Actions::CloudFormation::StackInitiationEvent.new(wrong_event).execute).to be(false)
    end

    it 'should return false because the event has the right resource status but the wrong resource type' do
      expect(AwsHelpers::Actions::CloudFormation::StackInitiationEvent.new(create_in_progress_event_wrong_type).execute).to be(false)
    end
  end
end
