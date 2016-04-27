module AwsHelpers
  module EC2Commands
    module Requests
      GetVpcIdRequest = Struct.new(
        :vpc_name,
        :vpc_id) do
          def initialize(*args)
            super(*args)
          end
        end
    end
  end
end
