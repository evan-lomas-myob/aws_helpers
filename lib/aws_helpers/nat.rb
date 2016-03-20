require_relative 'client'
require_relative 'actions/nat/gateway_create'
require_relative 'actions/nat/gateway_delete'

include AwsHelpers::Actions::NAT

module AwsHelpers

  class NAT < AwsHelpers::Client

    # Utilities for creation and deletion of NAT gateways
    # @param options [Hash] Optional Arguments to include when calling the AWS SDK
    def initialize(options = {})
      super(options)
    end

    # Create a NAT gateway
    # @param subnet_id [String] Id of the subnet to associate this gateway with
    # @param allocation_id [String] ID of the allocation associated with an Elastic IP address
    # @param [Hash] options Optional parameters that can be overridden.
    # @return [String] the gateway id
    def gateway_create(subnet_id, allocation_id)
      GatewayCreate.new(config, subnet_id, allocation_id).execute
    end

    # Delete a NAT gateway
    # @param gateway_id [String] the id of the NAT gateway
    def gateway_delete(gateway_id)
      GatewayDelete.new(config, gateway_id).execute
    end
  end

end

