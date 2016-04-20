module AwsHelpers
  module RDSCommands
    module Requests
      GetLatestSnapshotIdRequest = Struct.new(
          :std_out,
          :snapshot_id,
          :snapshot_name,
          :db_instance_identifier,
          :instance_polling,
          :snapshot_polling)
    end
  end
end
