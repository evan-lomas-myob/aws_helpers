require 'aws-sdk-core'
require 'aws_helpers/actions/cloud_formation/stack_completion_event'

describe AwsHelpers::Actions::CloudFormation::StackCompletionEvent do

  let(:stack_name) { 'name' }
  let(:complete_event) { create_stack_event(stack_name, 'DELETE_COMPLETE', 'AWS::CloudFormation::Stack') }
  let(:initiation_event) { create_stack_event(stack_name, 'CREATE_IN_PROGRESS', 'AWS::CloudFormation::Stack') }
  let(:initiation_event_with_bad_type) { create_stack_event(stack_name, 'CREATE_IN_PROGRESS', 'AWS::EC2::Instance') }

  describe '#execute' do
    it 'should return true because the event has a matching resource status' do
      expect(described_class.new(complete_event).execute).to be(true)
    end

    it 'should return false because the event has the wrong resource_status' do
      expect(described_class.new(initiation_event).execute).to be(false)
    end

    it 'should return false because the event has the right resource status but the wrong resource type' do
      expect(described_class.new(initiation_event_with_bad_type).execute).to be(false)
    end
  end

  def create_stack_event(stack_name, status, type)
    Aws::CloudFormation::Types::StackEvent.new(
        stack_name: stack_name,
        resource_status: status,
        resource_type: type)
  end

end
