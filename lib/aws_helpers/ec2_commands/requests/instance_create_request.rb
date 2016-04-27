module AwsHelpers
  module EC2Commands
    module Requests
      InstanceCreateRequest = Struct.new(
        :image_id,
        :instance_id,
        :instance_polling) do
          def initialize(*args)
            super(*args)
            self.instance_polling = {
              max_attempts: 2,
              delay: 30
            }
          end
        end
    end
  end
end
