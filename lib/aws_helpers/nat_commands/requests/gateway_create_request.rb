module AwsHelpers
  module NATCommands
    module Requests
      GatewayCreateRequest = Struct.new(
        :subnet_id,
        :allocation_id,
        :gateway_id)
    end
  end
end
