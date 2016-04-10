module AwsHelpers
  module EC2Commands
    module Requests
      ImageDeleteRequest = Struct.new(
        :stdout,
        :image_id,
        :snapshot_ids) do
          def initialize(*args)
            super(*args)
            self.stdout = $stdout
          end
        end
    end
  end
end
