module AwsHelpers
  module Actions
    module NAT

      class GatewayDelete

        def initialize(config, gateway_id)
          @config = config
          @gateway_id = gateway_id
        end

        def execute
          client = @config.aws_ec2_client
          client.delete_nat_gateway(nat_gateway_id: @gateway_id)
        end

      end
    end
  end
end