require 'aws-sdk-resources'
require 'aws_helpers/actions/cloud_formation/stack_completion_event'

include AwsHelpers::Actions::CloudFormation

describe StackCompletionEvent do

  let(:stack_name) { 'my_stack_name' }
  let(:resource_type) { 'AWS::CloudFormation::Stack' }
  let(:resource_type_bad) { 'AWS::EC2::Instance' }

  let(:complete_event) { instance_double(Aws::CloudFormation::Event,
                                         stack_name: stack_name,
                                         resource_status: 'DELETE_COMPLETE',
                                         resource_type: resource_type)
  }

  let(:initiation_event) { instance_double(Aws::CloudFormation::Event,
                                           stack_name: stack_name,
                                           resource_status: 'CREATE_IN_PROGRESS',
                                           resource_type: resource_type)
  }

  let(:initiation_event_with_bad_type) { instance_double(Aws::CloudFormation::Event,
                                                         stack_name: stack_name,
                                                         resource_status: 'CREATE_IN_PROGRESS',
                                                         resource_type: resource_type_bad)
  }


  describe '#execute' do

    it 'should return true because the event has a matching resource status' do
      expect(AwsHelpers::Actions::CloudFormation::StackCompletionEvent.new(complete_event).execute).to be(true)
    end

    it 'should return false because the event has the wrong resource_status' do
      expect(AwsHelpers::Actions::CloudFormation::StackCompletionEvent.new(initiation_event).execute).to be(false)
    end

    it 'should return false because the event has the right resource status but the wrong resource type' do
      expect(AwsHelpers::Actions::CloudFormation::StackCompletionEvent.new(initiation_event_with_bad_type).execute).to be(false)
    end

  end

end