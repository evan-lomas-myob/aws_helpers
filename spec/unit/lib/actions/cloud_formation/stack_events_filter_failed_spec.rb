require 'aws-sdk-resources'
require 'aws_helpers/actions/cloud_formation/stack_events_filter_failed'

include AwsHelpers::Actions::CloudFormation

describe StackEventsFilterFailed do

  let(:stack_name) { 'my_stack_name' }
  let(:resource_type) { 'AWS::CloudFormation::Stack' }
  let(:resource_type_bad) { 'AWS::EC2::Instance' }

  let(:create_failed_event) { instance_double(Aws::CloudFormation::Event,
                                              stack_name: stack_name,
                                              resource_status: 'CREATE_FAILED',
                                              resource_type: resource_type)
  }

  let(:delete_failed_event) { instance_double(Aws::CloudFormation::Event,
                                              stack_name: stack_name,
                                              resource_status: 'DELETE_FAILED',
                                              resource_type: resource_type)
  }

  let(:update_failed_event) { instance_double(Aws::CloudFormation::Event,
                                              stack_name: stack_name,
                                              resource_status: 'UPDATE_FAILED',
                                              resource_type: resource_type)
  }

  let(:rollback_failed_event) { instance_double(Aws::CloudFormation::Event,
                                                stack_name: stack_name,
                                                resource_status: 'ROLLBACK_FAILED',
                                                resource_type: resource_type)
  }

  let(:update_rollback_failed_event) { instance_double(Aws::CloudFormation::Event,
                                                       stack_name: stack_name,
                                                       resource_status: 'UPDATE_ROLLBACK_FAILED',
                                                       resource_type: resource_type)
  }

  let(:create_failed_event_wrong_type) { instance_double(Aws::CloudFormation::Event,
                                                         stack_name: stack_name,
                                                         resource_status: 'CREATE_FAILED',
                                                         resource_type: resource_type_bad)
  }

  let(:wrong_event) { instance_double(Aws::CloudFormation::Event,
                                      stack_name: stack_name,
                                      resource_status: 'DELETE_COMPLETE',
                                      resource_type: resource_type)
  }

  let(:stack_events_good) { [create_failed_event, delete_failed_event, update_failed_event, rollback_failed_event, update_rollback_failed_event ] }
  let(:stack_events_bad_resource) { [create_failed_event, delete_failed_event, wrong_event, update_failed_event, rollback_failed_event, update_rollback_failed_event ] }

  describe '#execute' do

    it 'should return the whole array stack because the events have matching resource status' do
      expect(AwsHelpers::Actions::CloudFormation::StackEventsFilterFailed.new(stack_events_good).execute).to eq(stack_events_good)
    end

    it 'should drop the event from array stack because the event has the wrong resource status' do
      expect(AwsHelpers::Actions::CloudFormation::StackEventsFilterFailed.new(stack_events_bad_resource).execute).to eq(stack_events_good)
    end

  end

end