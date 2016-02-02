require 'aws-sdk-core'

module AwsHelpers

  module NAT
    class Gateway

        # Utilities for creation and deletion of NAT gateways
        def initialize(ec2_client)
          @ec2_client = ec2_client
        end

        # Create a NAT gateway
        # @param subnet_id [String] Id of the subnet to associate this gateway with
        # @param allocation_id [String] ID of the allocation associated with an Elastic IP address
        # @param [Hash] options Optional parameters that can be overridden.
        # @return [String] the gateway id
        def create(subnet_id, allocation_id)
          result = @ec2_client.create_nat_gateway(subnet_id: subnet_id, allocation_id: allocation_id)
          result.nat_gateway.nat_gateway_id
        end

        # Delete a NAT gateway
        # @param gateway_id [String] the id of the NAT gateway
        def delete(gateway_id)
          @ec2_client.delete_nat_gateway(nat_gateway_id: gateway_id)
        end
    end
  end

end


