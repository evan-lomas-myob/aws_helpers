require 'aws_helpers/cloud_formation'
require 'aws_helpers/actions/cloud_formation/stack_error_events'
require 'aws_helpers/actions/cloud_formation/stack_retrieve_events'

describe StackErrorEvents do

  let(:cloudformation_client) { instance_double(Aws::CloudFormation::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_cloud_formation_client: cloudformation_client) }
  let(:stdout) { instance_double(IO) }

  let(:stack_retrieve_events) { instance_double(AwsHelpers::Actions::CloudFormation::StackRetrieveEvents)}

  let(:stack_name) { 'my_stack_name' }
  let(:next_token) { nil }
  let(:resource_type) { 'AWS::CloudFormation::Stack' }

  let(:initiation_event) { instance_double(Aws::CloudFormation::Event,
                    stack_name: stack_name,
                    resource_status: 'CREATE_IN_PROGRESS',
                    resource_type: resource_type)
  }

  let(:failed_event) { instance_double(Aws::CloudFormation::Event,
                    stack_name: stack_name,
                    resource_status: 'CREATE_FAILED',
                    resource_type: resource_type)
  }

  let(:complete_event) { instance_double(Aws::CloudFormation::Event,
                    stack_name: stack_name,
                    resource_status: 'DELETE_COMPLETE',
                    resource_type: resource_type )
  }

  let(:stack_events) { [initiation_event, failed_event, complete_event] }

  let(:describe_stack_events_output) { instance_double(Aws::CloudFormation::Types::DescribeStackEventsOutput, stack_events: stack_events, next_token: next_token) }

  it 'should call describe_stack_events to get events' do
    allow(StackRetrieveEvents).to receive(:new).with(config, stack_name).and_return(stack_retrieve_events)
    expect(stack_retrieve_events).to receive(:execute).and_return(stack_events)
    AwsHelpers::Actions::CloudFormation::StackErrorEvents.new(stdout, config, stack_name).execute
  end

end