module AwsHelpers
  module EC2Commands
    module Requests
      GetImageIdsRequest = Struct.new(
        :image_name,
        :image_ids,
        :older_than,
        :with_tags) do
          def initialize(*args)
            super(*args)
          end
        end
    end
  end
end
