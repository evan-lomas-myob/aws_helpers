require 'aws_helpers/command'

module AwsHelpers
  module NATCommands
    module Commands
      class GatewayDeleteCommand < AwsHelpers::Command
        def initialize(config, request)
          @client = config.aws_ec2_client
          @request = request
        end

        def execute
          @client.delete_nat_gateway(gateway_id: @request.gateway_id)
        end
      end
    end
  end
end
