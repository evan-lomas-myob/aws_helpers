module AwsHelpers
  module EC2Commands
    module Requests
      GetImageIdRequest = Struct.new(
        :image_name,
        :image_id) do
          def initialize(*args)
            super(*args)
          end
        end
    end
  end
end
