require 'aws_helpers/actions/ec2/poll_instance_healthy'
require 'aws_helpers/utilities/polling_options'


module AwsHelpers
  module Actions
    module EC2
      class InstanceStart
        include AwsHelpers::Utilities::PollingOptions

        def initialize(config, instance_id, options)
          @config = config
          @client = config.aws_ec2_client
          @instance_id = instance_id
          @stdout = options[:stdout] || $stdout
          @instance_healthy_options = create_options(@stdout, options[:poll_running])
        end

        def execute
          @stdout.puts("Starting #{@instance_id}")
          @client.start_instances(instance_ids: [@instance_id])
          AwsHelpers::Actions::EC2::PollInstanceHealthy.new(@config, @instance_id, @instance_healthy_options).execute
        end

      end
    end
  end
end
