require 'aws_helpers/command'

module AwsHelpers
  module EC2Commands
    module Commands
      class PollInstanceHealthyCommand < AwsHelpers::Command
        include AwsHelpers::Utilities::Polling

        def initialize(config, request)
          @ec2_client = config.aws_ec2_client
          @request = request
        end

        def execute
          poll(@request.instance_polling[:delay], @request.instance_polling[:max_attempts]) do
            instance = @ec2_client.describe_instances(instance_ids: [@request.instance_id]).reservations.first.instances.first
            healthy = false
            std_out.puts "EC2 Instance #{@request.instance_id} #{instance.state.name}"
            if instance && instance.state.name == 'running'
              if instance.platform == 'windows'
                response = @ec2_client.describe_instance_status(instance_ids: [@request.instance_id])
                status = response.instance_statuses.first.instance_status.status if response.instance_statuses.first
                healthy = true if status == 'ok'
              else
                healthy = true
              end
            end
            healthy
          end
        end
      end
    end
  end
end
