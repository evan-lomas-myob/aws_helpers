module AwsHelpers
  module RDSCommands
    module Requests
      SnapshotsDeleteRequest = Struct.new(
          :std_out,
          :snapshot_id,
          :db_instance_id,
          :older_than,
          :snapshot_name,
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
