module AwsHelpers
  module EC2Commands
    module Requests
      GetImageIdRequest = Struct.new(
        :image_name,
        :image_id,
        :stdout) do
          def initialize(*args)
            super(*args)
            self.stdout = $stdout
          end
        end
    end
  end
end
