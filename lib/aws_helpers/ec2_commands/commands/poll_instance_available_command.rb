require 'aws_helpers/actions/ec2/instance_state'
require 'aws_helpers/utilities/polling'
require 'aws_helpers/ec2_commands/commands/command'

module AwsHelpers
  module EC2Commands
    module Commands
      class PollInstanceAvailableCommand < AwsHelpers::EC2Commands::Commands::Command
        include AwsHelpers::Utilities::Polling

        def initialize(config, request)
          @ec2_client = config.aws_ec2_client
          @request = request
        end

        def execute
          poll(request.instance_polling[:delay], request.instance_polling[:max_attempts]) do
            response = @ec2_client.describe_instances(filters:
              [
                {
                  name: 'instance-id',
                  values: [request.instance_id]
                }
              ])
            instance = response.reservations.first.instances.first
            status = instance.state.name
            request.stdout.puts "EC2 Instance=#{@instance_identifier}, Status=#{status}"
            status == AwsHelpers::Actions::EC2::InstanceState::AVAILABLE
          end
        end
      end
    end
  end
end
