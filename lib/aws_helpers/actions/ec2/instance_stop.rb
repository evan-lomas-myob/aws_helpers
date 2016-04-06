require 'aws_helpers/actions/ec2/poll_instance_state'
require 'aws_helpers/utilities/polling_options'

module AwsHelpers
  module Actions
    module EC2
      class InstanceStop
        include AwsHelpers::Utilities::PollingOptions

        def initialize(config, instance_id, options)
          @config = config
          @client = config.aws_ec2_client
          @instance_id = instance_id
          @stdout = options[:stdout] || $stdout
          @instance_stopped_options = create_options(@stdout, options[:poll_stopped])
        end

        def execute
          @stdout.puts("Stopping #{@instance_id}")
          @client.stop_instances(instance_ids: [@instance_id])
          AwsHelpers::Actions::EC2::PollInstanceState.new(@config, @instance_id, 'stopped', @instance_stopped_options).execute
        end

      end
    end
  end
end
