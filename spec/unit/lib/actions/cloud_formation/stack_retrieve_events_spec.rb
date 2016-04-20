require 'aws_helpers'
require_relative '../../../spec_helpers/create_event_helper'

describe AwsHelpers::Actions::CloudFormation::StackRetrieveEvents do
  let(:cloudformation_client) { instance_double(Aws::CloudFormation::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_cloud_formation_client: cloudformation_client) }
  let(:stack_resource) { instance_double(Aws::CloudFormation::Stack) }

  let(:stack_name) { 'my_stack_name' }
  let(:stack_id) { 'id' }

  let(:failed_event) { CreateEventHelper.new(stack_name, stack_id, 'CREATE_FAILED', 'resource_type').execute }
  let(:complete_event) { CreateEventHelper.new(stack_name, stack_id, 'DELETE_COMPLETE', 'resource_type').execute }

  describe '#execute' do

    subject { AwsHelpers::Actions::CloudFormation::StackRetrieveEvents.new(config, stack_id).execute }

    context 'next_token has a value' do

      let(:token) { 'token' }

      context 'Aws::CloudFormation::Client #describe_stack_events does not have a stack initiation event' do

        before(:each) do
          allow(cloudformation_client).to receive(:describe_stack_events).and_return(
              create_output([complete_event], token),
              create_output([failed_event], nil))
        end

        it 'should call Aws::CloudFormation::Client #describe_stack_events until next_token is nil' do
          expect(cloudformation_client).to receive(:describe_stack_events).with(stack_name: stack_id, next_token: nil).ordered
          expect(cloudformation_client).to receive(:describe_stack_events).with(stack_name: stack_id, next_token: token).ordered
          subject
        end

        it 'should return all events from multiple calls to Aws::CloudFormation::Client #describe_stack_events' do
          expect(subject).to eql([complete_event, failed_event])
        end

      end

      context 'Aws::CloudFormation::Client #describe_stack_events has a stack initiation event' do

        %w( CREATE_IN_PROGRESS UPDATE_IN_PROGRESS DELETE_IN_PROGRESS ).each do |resources_status|
          resource_type = 'AWS::CloudFormation::Stack'
          it "should stop calling Aws::CloudFormation::Client #describe_stack_events when an event type of #{resource_type}, #{resources_status} is found" do
            initiation_event = CreateEventHelper.new(stack_name, stack_id, resources_status, resource_type).execute
            allow(cloudformation_client).to receive(:describe_stack_events).and_return(
                create_output([complete_event, initiation_event], token),
                create_output([failed_event], token),
            )
            expect(subject).to eql([complete_event, initiation_event])
          end

        end

      end

    end

    context 'next_token is nil' do

      before(:each) do
        allow(cloudformation_client).to receive(:describe_stack_events).and_return(create_output([complete_event], nil))
      end

      it 'should call Aws::CloudFormation::Client #describe_stack_events with correct parameters' do
        expect(cloudformation_client).to receive(:describe_stack_events).with(stack_name: stack_id, next_token: nil)
        subject
      end

    end

    def create_output(events, token)
      Aws::CloudFormation::Types::DescribeStackEventsOutput.new(stack_events: events, next_token: token)
    end

  end
end
