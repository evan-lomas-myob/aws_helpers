module AwsHelpers
  module Actions
    module CloudFormation

      class StackEventsFilterFailed

        def initialize(events)
          @events = events
        end

        def execute
          @events.select { |event|
            %w(CREATE_FAILED DELETE_FAILED UPDATE_FAILED ROLLBACK_FAILED UPDATE_ROLLBACK_FAILED ).include?(event.resource_status)
          }
        end

      end
    end
  end
end