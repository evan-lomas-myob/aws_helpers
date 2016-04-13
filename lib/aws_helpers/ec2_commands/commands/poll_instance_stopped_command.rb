require 'aws_helpers/ec2_commands/commands/command'

module AwsHelpers
  module EC2Commands
    module Commands
      class PollInstanceStoppedCommand < AwsHelpers::EC2Commands::Commands::Command
        include AwsHelpers::Utilities::Polling

        def initialize(config, request)
          @ec2_client = config.aws_ec2_client
          @request = request
        end

        def execute
          poll(@request.instance_polling[:delay], @request.instance_polling[:max_attempts]) do
            response = @ec2_client.describe_instances(instance_ids: [@request.instance_id])
            state = response.reservations.first.instances.first.state
            @request.stdout.puts "EC2 Instance #{@request.instance_id} #{state}"
            state == 'stopped'
          end
        end
      end
    end
  end
end
