module AwsHelpers
  module Actions
    module CloudFormation

      class StackCompletionEvent

        def initialize(event)
          @event = event
        end

        def execute
          event_list = %w( DELETE_COMPLETE )
          event_list.include?(@event.resource_status) && @event.resource_type == 'AWS::CloudFormation::Stack'
        end

      end
    end
  end
end