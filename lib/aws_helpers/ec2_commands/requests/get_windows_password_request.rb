module AwsHelpers
  module EC2Commands
    module Requests
      GetWindowsPasswordRequest = Struct.new(
        :instance_id,
        :pem_path,
        :windows_password) do
          def initialize(*args)
            super(*args)
          end
        end
    end
  end
end
