module AwsHelpers
  module EC2Commands
    module Requests
      InstanceCreateRequest = Struct.new(
        :instance_id,
        :image_id,
        :image_name,
        :use_name,
        :instance_polling,
        :stdout,
        :image_polling) do
          def initialize(*args)
            super(*args)
            self.stdout = $stdout
            self.instance_polling = {
              max_attempts: 60,
              delay: 30
            }
            self.image_polling = {
              max_attempts: 60,
              delay: 30
            }
          end
        end
    end
  end
end
