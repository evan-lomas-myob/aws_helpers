require 'aws_helpers/cloud_formation'
require 'aws_helpers/actions/cloud_formation/stack_error_events'
require 'aws_helpers/actions/cloud_formation/stack_retrieve_events'
require 'aws_helpers/actions/cloud_formation/stack_events_filter_post_initiation'
require 'aws_helpers/actions/cloud_formation/stack_events_filter_failed'

include AwsHelpers::Actions::CloudFormation

describe StackErrorEvents do

  let(:cloudformation_client) { instance_double(Aws::CloudFormation::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_cloud_formation_client: cloudformation_client) }
  let(:stdout) { instance_double(IO) }

  let(:stack_retrieve_events) { instance_double(AwsHelpers::Actions::CloudFormation::StackRetrieveEvents) }
  let(:stack_events_filter_post_initiation) { instance_double(AwsHelpers::Actions::CloudFormation::StackEventsFilterPostInitiation) }
  let(:stack_events_filter_failed) { instance_double(AwsHelpers::Actions::CloudFormation::StackEventsFilterFailed) }

  let(:stack_name) { 'my_stack_name' }
  let(:resource_type) { 'AWS::CloudFormation::Stack' }
  let(:timestamp) { Time.parse('01-Jan-2015 00:00:00') }
  let(:logical_resource_id) { 'ResourceID' }
  let(:resource_status_reason) { 'Success/failure message' }
  let(:next_token) { nil }

  let(:initiation_event) { CreateEventHelper.new(stack_name, 'CREATE_IN_PROGRESS', resource_type).execute }
  let(:failed_event) { CreateEventHelper.new(stack_name, 'CREATE_FAILED', resource_type).execute }
  let(:complete_event) { CreateEventHelper.new(stack_name, 'DELETE_COMPLETE', resource_type).execute }

  let(:stack_events) { [complete_event, failed_event, initiation_event] }

  let(:describe_stack_events_output) { instance_double(Aws::CloudFormation::Types::DescribeStackEventsOutput, stack_events: stack_events, next_token: next_token) }

  before(:each) do
    allow(cloudformation_client).to receive(:describe_stack_events).with(stack_name: stack_name, next_token: next_token).and_return(describe_stack_events_output)
    allow(AwsHelpers::Actions::CloudFormation::StackRetrieveEvents).to receive(:new).with(config, stack_name).and_return(stack_retrieve_events)
    allow(stack_retrieve_events).to receive(:execute).and_return(stack_events)
    allow(AwsHelpers::Actions::CloudFormation::StackEventsFilterPostInitiation).to receive(:new).with(stack_events).and_return(stack_events_filter_post_initiation)
    allow(stack_events_filter_post_initiation).to receive(:execute).and_return(stack_events)
    allow(AwsHelpers::Actions::CloudFormation::StackEventsFilterFailed).to receive(:new).with(stack_events).and_return(stack_events_filter_failed)
    allow(stack_events_filter_failed).to receive(:execute).and_return(stack_events)
    allow(stack_events_filter_failed).to receive(:execute).and_return(stack_events)
    allow(stdout).to receive(:puts).with(anything)
  end

  after(:each) do
    AwsHelpers::Actions::CloudFormation::StackErrorEvents.new(config, stack_name, stdout).execute
  end

  it 'should call StackRetrieveEvents to get events' do
    expect(stack_retrieve_events).to receive(:execute).and_return(stack_events)
  end

  it 'should call StackEventsFilterPostInitiation to collect problem events' do
    expect(stack_events_filter_post_initiation).to receive(:execute).and_return(stack_events)
  end

  it 'should call StackEventsFilterFailed filter out events that have failed' do
    expect(stack_events_filter_failed).to receive(:execute).and_return(stack_events)
  end

  it 'should send event information to standard output' do
    expect(stdout).to receive(:puts).with("#{timestamp}, DELETE_COMPLETE, #{logical_resource_id}, #{resource_status_reason}")
  end

end