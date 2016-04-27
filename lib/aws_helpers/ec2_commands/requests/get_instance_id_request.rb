module AwsHelpers
  module EC2Commands
    module Requests
      GetInstanceIdRequest = Struct.new(
        :instance_name,
        :instance_id) do
          def initialize(*args)
            super(*args)
          end
        end
    end
  end
end
