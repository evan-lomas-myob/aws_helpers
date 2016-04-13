module AwsHelpers
  module EC2Commands
    module Requests
      PollInstanceHealthyRequest = Struct.new(
        :instance_id,
        :instance_polling,
        :stdout) do
          def initialize(*args)
            super(*args)
            self.stdout = $stdout
            self.instance_polling = {
              max_attempts: 2,
              delay: 30
            }
          end
        end
    end
  end
end
