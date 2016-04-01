module AwsHelpers
  module Actions
    module CloudFormation
      class StackInitiationEvent
        def initialize(event)
          @event = event
        end

        def execute
          event_list = %w( CREATE_IN_PROGRESS UPDATE_IN_PROGRESS DELETE_IN_PROGRESS )
          event_list.include?(@event.resource_status) && @event.resource_type == 'AWS::CloudFormation::Stack'
        end
      end
    end
  end
end
