require 'aws_helpers/utilities/polling'

include AwsHelpers::Utilities

module AwsHelpers
  module Actions
    module EC2

      class PollInstanceState

        include AwsHelpers::Utilities::Polling

        def initialize(config, instance_id, state, options = {})
          @client = config.aws_ec2_client
          @instance_id = instance_id
          @state = state
          @stdout = options[:stdout] || $stdout
          @delay = options[:delay] || 15
          @max_attempts = options[:max_attempts] || 8
        end

        def execute
          poll(@delay, @max_attempts) {
            current_state = @client.describe_instances({ instance_ids: [@instance_id]}).reservations.first.instances.first.state.name
            @stdout.puts "Instance State is #{current_state}."
            current_state == @state
          }
        end

      end
    end
  end
end

