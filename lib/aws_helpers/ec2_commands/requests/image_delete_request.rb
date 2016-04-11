module AwsHelpers
  module EC2Commands
    module Requests
      ImageDeleteRequest = Struct.new(
        :stdout,
        :image_id,
        :snapshot_ids,
        :image_polling) do
          def initialize(*args)
            super(*args)
            self.stdout = $stdout
            self.image_polling = {
              max_attempts: 2,
              delay: 30
            }
          end
        end
    end
  end
end
