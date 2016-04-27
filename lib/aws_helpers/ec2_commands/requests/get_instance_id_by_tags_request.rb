module AwsHelpers
  module EC2Commands
    module Requests
      GetInstanceIdByTagsRequest = Struct.new(
        :instance_name,
        :instance_id,
        :tags,
        :stdout) do
          def initialize(*args)
            super(*args)
            self.stdout = $stdout
          end
        end
    end
  end
end
