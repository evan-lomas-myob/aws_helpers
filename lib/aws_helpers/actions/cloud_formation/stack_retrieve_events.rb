require 'aws_helpers/actions/cloud_formation/stack_initiation_event'
require 'aws_helpers/utilities/target_stack_validate'

module AwsHelpers
  module Actions
    module CloudFormation
      class StackRetrieveEvents
        def initialize(config, options)
          @config = config
          @target_stack = AwsHelpers::Utilities::TargetStackValidate.new.execute(options)
        end

        def execute
          client = @config.aws_cloud_formation_client
          events = []
          next_token = nil

          loop do
            response = client.describe_stack_events(stack_name: @target_stack, next_token: next_token)
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
