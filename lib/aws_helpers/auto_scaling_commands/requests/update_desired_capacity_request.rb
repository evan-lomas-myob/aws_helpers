module AwsHelpers
  module AutoScalingCommands
    module Requests
      UpdateDesiredCapacityRequest = Struct.new(
        :desired_capacity,
        :auto_scaling_group_name)
    end
  end
end
