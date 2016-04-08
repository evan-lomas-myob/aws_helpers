require 'aws_helpers'
require_relative '../../../spec_helpers/create_event_helper'

describe AwsHelpers::Actions::CloudFormation::StackEventsFilterFailed do

  describe '#execute' do

    context 'failed events' do

      %w(CREATE_FAILED DELETE_FAILED UPDATE_FAILED ROLLBACK_FAILED UPDATE_ROLLBACK_FAILED).each { |status|
        events = [CreateEventHelper.new('name', 'id', status, 'AWS::CloudFormation::Stack').execute]
        it "should return the #{status} event" do
          expect(AwsHelpers::Actions::CloudFormation::StackEventsFilterFailed.new(events).execute).to eql(events)
        end
      }

    end

    context 'other events' do

      %w(OTHER).each { |status|
        events = [CreateEventHelper.new('name', 'id', status, 'AWS::CloudFormation::Stack').execute]
        it 'should return an empty array' do
          expect(AwsHelpers::Actions::CloudFormation::StackEventsFilterFailed.new(events).execute).to eql([])
        end
      }

    end


  end
end
