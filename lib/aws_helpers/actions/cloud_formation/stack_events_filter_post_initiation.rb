require 'aws_helpers/actions/cloud_formation/stack_initiation_event'
require 'aws_helpers/actions/cloud_formation/stack_completion_event'

module AwsHelpers
  module Actions
    module CloudFormation

      class StackEventsFilterPostInitiation

        def initialize(events)
          @events = events
        end

        def execute
          result = []
          @events.each { |event|
            result << event
            break if AwsHelpers::Actions::CloudFormation::StackInitiationEvent.new(event).execute ||
                AwsHelpers::Actions::CloudFormation::StackCompletionEvent.new(event).execute
          }
          result
        end

      end
    end
  end
end