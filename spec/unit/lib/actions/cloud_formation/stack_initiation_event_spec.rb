require 'aws_helpers'
require_relative '../../../spec_helpers/create_event_helper'

describe AwsHelpers::Actions::CloudFormation::StackInitiationEvent do

  describe '#execute' do

    context 'with the event with resource_type AWS::CloudFormation::Stack' do

      resource_type = 'AWS::CloudFormation::Stack'

      %w( CREATE_IN_PROGRESS UPDATE_IN_PROGRESS DELETE_IN_PROGRESS ).each {|event_type|
        event = CreateEventHelper.new('name', 'id', event_type, resource_type).execute
        it "should return true because the #{event_type} is and initiation event" do
          expect(AwsHelpers::Actions::CloudFormation::StackInitiationEvent.new(event).execute).to be(true)
        end
      }

      %w( OTHER ).each {|event_type|
        event = CreateEventHelper.new('name', 'id', event_type, resource_type).execute
        it "'should return false'" do
          expect(AwsHelpers::Actions::CloudFormation::StackInitiationEvent.new(event).execute).to be(false)
        end
      }

    end

    context 'with any other event with resource_type' do

      %w( CREATE_IN_PROGRESS OTHER).each {|event_type|
        event = CreateEventHelper.new('name', 'id', event_type, 'AWS::CloudFormation::Other').execute
        it "should return false with #{event_type}" do
          expect(AwsHelpers::Actions::CloudFormation::StackInitiationEvent.new(event).execute).to be(false)
        end
      }

    end

  end
end
