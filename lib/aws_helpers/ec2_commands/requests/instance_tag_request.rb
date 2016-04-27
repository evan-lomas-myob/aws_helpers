module AwsHelpers
  module EC2Commands
    module Requests
      InstanceTagRequest = Struct.new(
        :instance_id,
        :tags) do
          def initialize(*args)
            super(*args)
          end
        end
    end
  end
end
