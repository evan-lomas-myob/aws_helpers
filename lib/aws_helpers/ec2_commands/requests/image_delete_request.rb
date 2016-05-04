module AwsHelpers
  module EC2Commands
    module Requests
      ImageDeleteRequest = Struct.new(
        :image_id,
        :snapshot_ids,
        :image_polling) do
          def initialize(*args)
            super(*args)
            self.image_polling = {
              max_attempts: 8,
              delay: 30
            }
          end
        end
    end
  end
end
