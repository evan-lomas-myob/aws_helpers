module AwsHelpers
  module EC2Commands
    module Requests
      GetWindowsPasswordRequest = Struct.new(
        :instance_id,
        :pem_path,
        :windows_password,
        :stdout) do
          def initialize(*args)
            super(*args)
            self.stdout = $stdout
          end
        end
    end
  end
end
