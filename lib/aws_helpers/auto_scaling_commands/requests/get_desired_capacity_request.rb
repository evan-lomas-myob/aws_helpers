module AwsHelpers
  module AutoScalingCommands
    module Requests
      GetDesiredCapacityRequest = Struct.new(
        :desired_capacity,
        :auto_scaling_group_name)
    end
  end
end
