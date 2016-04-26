require 'aws_helpers/command'

module AwsHelpers
  module EC2Commands
    module Commands
      class PollInstanceAvailableCommand < AwsHelpers::Command
        # include AwsHelpers::Utilities::Polling

        def initialize(config, request)
          @ec2_client = config.aws_ec2_client
          @request = request
        end

        def execute
          poll(@request.instance_polling[:delay], @request.instance_polling[:max_attempts]) do
            instance = @ec2_client.describe_instances(instance_ids: [@request.instance_id]).reservations.first.instances.first
            status = instance.state
            @request.stdout.puts "EC2 Instance #{@request.instance_id} #{status}"
            status == 'available'
          end
        end
      end
    end
  end
end
