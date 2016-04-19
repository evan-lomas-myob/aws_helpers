require 'aws_helpers/nat_commands/commands/command'

module AwsHelpers
  module NATCommands
    module Commands
      class GatewayCreateCommand < AwsHelpers::NATCommands::Commands::Command
        def initialize(config, request)
          @client = config.aws_ec2_client
          @request = request
        end

        def execute
          result = @client.create_nat_gateway(subnet_id: @request.subnet_id, allocation_id: @request.allocation_id)
          @request.gateway_id = result.nat_gateway.nat_gateway_id
        end
      end
    end
  end
end
