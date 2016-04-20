module AwsHelpers
  module ELBCommands
    module Requests
      PollInServiceInstancesRequest = Struct.new(
        :load_balancer_name,
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
