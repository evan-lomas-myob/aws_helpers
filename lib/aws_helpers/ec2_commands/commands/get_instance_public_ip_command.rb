require 'aws_helpers/command'

module AwsHelpers
  module EC2Commands
    module Commands
      class GetInstancePublicIpCommand < AwsHelpers::Command
        def initialize(config, request)
          @client = config.aws_ec2_client
          @request = request
        end

        def execute
          response = @client.describe_instances(instance_ids: [@request.instance_id])
          puts "Command response: #{response.to_s}"
          @request.instance_public_ip = response.reservations.first.instances.first.public_ip_address unless response.reservations.empty?
        end
      end
    end
  end
end
