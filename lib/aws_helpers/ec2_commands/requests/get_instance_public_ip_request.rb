module AwsHelpers
  module EC2Commands
    module Requests
      GetInstancePublicIpRequest = Struct.new(
        :instance_id,
        :instance_public_ip) do
          def initialize(*args)
            super(*args)
          end
        end
    end
  end
end
