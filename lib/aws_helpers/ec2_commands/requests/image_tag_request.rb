module AwsHelpers
  module EC2Commands
    module Requests
      ImageTagRequest = Struct.new(
        :image_id,
        :tags) do
          def initialize(*args)
            super(*args)
          end
        end
    end
  end
end
