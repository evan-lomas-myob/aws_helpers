module AwsHelpers
  module Actions
    module NAT
      class GatewayCreate
        def initialize(config, subnet_id, allocation_id)
          @config = config
          @subnet_id = subnet_id
          @allocation_id = allocation_id
        end

        def execute
          client = @config.aws_ec2_client
          result = client.create_nat_gateway(subnet_id: @subnet_id, allocation_id: @allocation_id)
          result.nat_gateway.nat_gateway_id
        end
      end
    end
  end
end
