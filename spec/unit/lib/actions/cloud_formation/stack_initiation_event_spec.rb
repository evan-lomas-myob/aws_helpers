require 'aws-sdk-resources'
require 'aws_helpers/actions/cloud_formation/stack_initiation_event'

include AwsHelpers::Actions::CloudFormation

describe StackInitiationEvent do

  let(:stack_name) { 'my_stack_name' }
  let(:resource_type) { 'AWS::CloudFormation::Stack' }
  let(:resource_type_bad) { 'AWS::EC2::Instance' }

  let(:create_in_progress_event) { instance_double(Aws::CloudFormation::Event,
                                                   stack_name: stack_name,
                                                   resource_status: 'CREATE_IN_PROGRESS',
                                                   resource_type: resource_type)
  }

  let(:update_in_progress_event) { instance_double(Aws::CloudFormation::Event,
                                                   stack_name: stack_name,
                                                   resource_status: 'UPDATE_IN_PROGRESS',
                                                   resource_type: resource_type)
  }

  let(:delete_in_progress_event) { instance_double(Aws::CloudFormation::Event,
                                                   stack_name: stack_name,
                                                   resource_status: 'DELETE_IN_PROGRESS',
                                                   resource_type: resource_type)
  }

  let(:create_in_progress_event_wrong_type) { instance_double(Aws::CloudFormation::Event,
                                                              stack_name: stack_name,
                                                              resource_status: 'CREATE_IN_PROGRESS',
                                                              resource_type: resource_type_bad)
  }

  let(:wrong_event) { instance_double(Aws::CloudFormation::Event,
                                      stack_name: stack_name,
                                      resource_status: 'DELETE_COMPLETE',
                                      resource_type: resource_type)
  }

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