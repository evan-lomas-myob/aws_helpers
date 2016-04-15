module AwsHelpers
  module RDSCommands
    module Requests
      SnapshotCreateRequest = Struct.new(
          :std_out,
          :db_snapshot_identifier,
          :snapshot_name,
          :db_instance_identifier,
          :instance_polling,
          :snapshot_polling)
    end
  end
end
