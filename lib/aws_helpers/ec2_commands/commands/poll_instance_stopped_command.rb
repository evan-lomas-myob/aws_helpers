require 'aws_helpers/command'

module AwsHelpers
  module EC2Commands
    module Commands
      class PollInstanceStoppedCommand < AwsHelpers::Command
        include AwsHelpers::Utilities::Polling

        def initialize(config, request)
          @ec2_client = config.aws_ec2_client
          @request = request
        end

        def execute
          poll(@request.instance_polling[:delay], @request.instance_polling[:max_attempts]) do
            response = @ec2_client.describe_instances(instance_ids: [@request.instance_id])
            state = response.reservations.first.instances.first.state
            std_out.puts "EC2 Instance #{@request.instance_id} #{state}"
            state == 'stopped'
          end
        end
      end
    end
  end
end
