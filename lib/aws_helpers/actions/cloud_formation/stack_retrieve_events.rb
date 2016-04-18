require 'aws_helpers/actions/cloud_formation/stack_initiation_event'

module AwsHelpers
  module Actions
    module CloudFormation
      class StackRetrieveEvents
        def initialize(config, stack_id)
          @config = config
          @stack_id = stack_id
        end

        def execute
          client = @config.aws_cloud_formation_client
          events = []
          next_token = nil

          loop do
            response = client.describe_stack_events(stack_name: @stack_id, next_token: next_token)
            next_token = response.next_token
            events.concat(response.stack_events)
            break if response.stack_events.detect { |event| AwsHelpers::Actions::CloudFormation::StackInitiationEvent.new(event).execute } || next_token.nil?
          end
          events
        end
      end
    end
  end
end
