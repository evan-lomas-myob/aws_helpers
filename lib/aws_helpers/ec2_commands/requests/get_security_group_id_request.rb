module AwsHelpers
  module EC2Commands
    module Requests
      GetSecurityGroupIdRequest = Struct.new(
        :security_group_name,
        :security_group_id,
        :stdout) do
          def initialize(*args)
            super(*args)
            self.stdout = $stdout
          end
        end
    end
  end
end
