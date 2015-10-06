require 'aws_helpers/actions/ec2/poll_instance_healthy'

module AwsHelpers
  module Actions
    module EC2

      class InstanceStart

        def initialize(config, instance_id, options)
          @config = config
          @instance_id = instance_id
          @stdout = options[:stdout] || $stdout
          @instance_running_polling = create_polling_options(@stdout, options[:instance_running])
        end

        def execute
          @stdout.puts("Starting #{@instance_id}")
          client = @config.aws_ec2_client
          client.start_instances(instance_ids: [@instance_id])
          AwsHelpers::Actions::EC2::PollInstanceHealthy.new(@instance_id, @instance_running_polling).execute
        end

        def create_polling_options(stdout, polling)
          options = {}
          options[:stdout] = stdout
          if polling
            max_attempts = polling[:max_attempts]
            delay = polling[:delay]
            options[:max_attempts] = max_attempts if max_attempts
            options[:delay] = delay if delay
          end
          options
        end

      end
    end
  end
end
