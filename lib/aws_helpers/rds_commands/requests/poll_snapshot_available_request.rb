module AwsHelpers
  module RDSCommands
    module Requests
      PollSnapshotAvailableRequest = Struct.new(
          :std_out,
          :db_instance_id,
          :snapshot_name,
          :use_name,
          :snapshot_polling) do
            def initialize(*args)
              super(*args)
              self.snapshot_polling = {
                max_attempts: 8,
                delay: 30
              }
            end
          end
    end
  end
end
