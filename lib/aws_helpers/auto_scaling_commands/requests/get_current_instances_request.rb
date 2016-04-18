module AwsHelpers
  module AutoScalingCommands
    module Requests
      GetCurrentInstancesRequest = Struct.new(
        :current_instances,
        :auto_scaling_group_name)
    end
  end
end
