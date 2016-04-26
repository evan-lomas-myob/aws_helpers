module AwsHelpers
  module EC2Commands
    module Requests
      GetRunningInstanceIdsRequest = Struct.new(
        :running_instance_ids,
        :instance_ids) do
          def initialize(*args)
            super(*args)
          end
        end
    end
  end
end
