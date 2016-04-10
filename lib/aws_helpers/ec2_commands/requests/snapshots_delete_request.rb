module AwsHelpers
  module EC2Commands
    module Requests
      SnapshotsDeleteRequest = Struct.new(
        :stdout,
        :snapshot_ids) do
          def initialize(*args)
            super(*args)
            self.stdout = $stdout
          end
        end
    end
  end
end
