module AwsHelpers
  module RDSCommands
    module Requests
      SnapshotCreateRequest = Struct.new(
          :std_out,
          :snapshot_id,
          :snapshot_name,
          :db_instance_id,
          :instance_polling,
          :snapshot_polling) do
            def initialize(*args)
              super(*args)
              self.snapshot_polling = {
                max_attempts: 8,
                delay: 30
              }
              self.instance_polling = {
                max_attempts: 8,
                delay: 30
              }
            end
          end
    end
  end
end
