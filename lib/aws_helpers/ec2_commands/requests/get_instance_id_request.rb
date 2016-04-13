module AwsHelpers
  module EC2Commands
    module Requests
      GetInstanceIdRequest = Struct.new(
        :instance_name,
        :instance_id,
        :stdout) do
          def initialize(*args)
            super(*args)
            self.stdout = $stdout
          end
        end
    end
  end
end
