require 'aws_helpers/actions/ec2/poll_instance_healthy'

module AwsHelpers
  module Actions
    module EC2
      class InstanceStart
        def initialize(config, instance_id, options)
          @config = config
          @client = config.aws_ec2_client
          @instance_id = instance_id
          @stdout = options[:stdout] || $stdout
          @instance_healthy_options = instance_healthy_options(@stdout, options[:poll_running])
        end

        def execute
          @stdout.puts("Starting #{@instance_id}")
          @client.start_instances(instance_ids: [@instance_id])
          AwsHelpers::Actions::EC2::PollInstanceHealthy.new(@config, @instance_id, @instance_healthy_options).execute
        end

        def instance_healthy_options(stdout, polling)
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
