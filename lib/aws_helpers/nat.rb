require_relative 'client'
Dir.glob(File.join(File.dirname(__FILE__), 'nat_commands/**/*.rb'), &method(:require))

include AwsHelpers::NATCommands::Directors
include AwsHelpers::NATCommands::Requests
# include AwsHelpers::Actions::NAT

module AwsHelpers
  class NAT < AwsHelpers::Client
    # Utilities for creation and deletion of NAT gateways
    #
    # @param options [Hash] Optional arguments to include when calling the AWS SDK. These arguments will
    #   affect all clients used by this helper. See the {http://docs.aws.amazon.com/sdkforruby/api/Aws/EC2/Client.html#initialize-instance_method AWS documentation}
    #   for a list of EC2 client options.
    #
    # @example Create a NAT Client
    #   AwsHelpers.NAT.new
    #
    # @return [AwsHelpers::NAT]
    #

    def initialize(options = {})
      super(options)
    end

    # Create a NAT gateway
    #
    # @param subnet_id [String] Id of the subnet to associate this gateway with
    # @param allocation_id [String] ID of the allocation associated with an Elastic IP address
    #
    # @example Get the gateway ID
    #   AwsHelpers::NAT.new.gateway_create('subnet-a2bc11ab','eipalloc-1ab1234')
    #
    # @return [String] the gateway id
    #
    def gateway_create(subnet_id, allocation_id)
      request = GatewayCreateRequest.new(subnet_id: subnet_id, allocation_id: allocation_id)
      GatewayCreateDirector.new(config).create(request)
    end

    # Delete a NAT gateway
    #
    # @param gateway_id [String] the id of the NAT gateway
    #
    # @example Delete the NAT gateway
    #   AwsHelpers::NAT.new.gateway_delete('nat-123ab12aa01bbbbaa')
    #
    # @return [struct Aws::EC2::Types::DeleteNatGatewayResult] contains the gateway id
    #
    def gateway_delete(gateway_id)
      request = GatewayDeleteRequest.new(gateway_id: gateway_id)
      GatewayDeleteDirector.new(config).delete(request)
    end
  end
end
