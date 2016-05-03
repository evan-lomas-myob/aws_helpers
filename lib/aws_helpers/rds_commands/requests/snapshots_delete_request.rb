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
          :snapshot_polling)
    end
  end
end
