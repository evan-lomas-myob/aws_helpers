module AwsHelpers
  module EC2Commands
    module Requests
      GetSecurityGroupIdRequest = Struct.new(
        :security_group_name,
        :security_group_id) do
          def initialize(*args)
            super(*args)
          end
        end
    end
  end
end
