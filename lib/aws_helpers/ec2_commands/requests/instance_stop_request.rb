module AwsHelpers
  module EC2Commands
    module Requests
      InstanceStopRequest = Struct.new(
        :instance_id) do
          def initialize(*args)
            super(*args)
          end
        end
    end
  end
end
