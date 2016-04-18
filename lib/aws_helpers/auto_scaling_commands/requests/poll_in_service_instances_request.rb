module AwsHelpers
  module AutoScalingCommands
    module Requests
      PollInServiceInstancesRequest = Struct.new(
        :current_instances,
        :auto_scaling_group_name,
        :desired_instances,
        :instance_polling) do
          def initialize(*args)
            super(*args)
            self.instance_polling = {
              max_attempts: 60,
              delay: 30
            }
          end
        end
    end
  end
end
