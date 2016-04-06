module AwsHelpers
  module Actions
    module CloudFormation
      class StackCompletionEvent
        def initialize(event)
          @event = event
        end

        def execute
          delete_complete? && stack_resource?
        end

        private

        def delete_complete?
          ['DELETE_COMPLETE'].include?(@event.resource_status)
        end

        def stack_resource?
          @event.resource_type == 'AWS::CloudFormation::Stack'
        end

      end
    end
  end
end
