module AwsHelpers
  module EC2Commands
    module Requests
      GetVpcIdRequest = Struct.new(
        :vpc_name,
        :vpc_id,
        :stdout) do
          def initialize(*args)
            super(*args)
            self.stdout = $stdout
          end
        end
    end
  end
end
