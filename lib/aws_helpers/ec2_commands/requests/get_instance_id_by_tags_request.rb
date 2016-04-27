module AwsHelpers
  module EC2Commands
    module Requests
      GetInstanceIdByTagsRequest = Struct.new(
        :instance_name,
        :instance_id,
        :tags) do
          def initialize(*args)
            super(*args)
          end
        end
    end
  end
end
