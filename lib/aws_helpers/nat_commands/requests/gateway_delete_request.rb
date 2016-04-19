module AwsHelpers
  module NATCommands
    module Requests
      GatewayDeleteRequest = Struct.new(
        :subnet_id,
        :allocation_id,
        :gateway_id)
    end
  end
end
