require 'aws_helpers/ec2_commands/commands/command'

module AwsHelpers
  module EC2Commands
    module Commands
      class PollInstanceHealthyCommand < AwsHelpers::EC2Commands::Commands::Command
        include AwsHelpers::Utilities::Polling

        def initialize(config, request)
          @ec2_client = config.aws_ec2_client
          @request = request
        end

        def execute
          poll(@request.instance_polling[:delay], @request.instance_polling[:max_attempts]) do
            response = @ec2_client.describe_instance_status(instance_ids: [@request.instance_id])
            status = response.instance_statuses.first.instance_status.status if response.instance_statuses.first
            @request.stdout.puts "EC2 Instance #{@request.instance_id} #{status}"
            status == 'available' || status == 'ok'
          end
        end
      end
    end
  end
end
