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
          results = []
          @events.each do |event|
            results << event
            break if StackInitiationEvent.new(event).execute || StackCompletionEvent.new(event).execute
          end
          results
        end
      end
    end
  end
end
