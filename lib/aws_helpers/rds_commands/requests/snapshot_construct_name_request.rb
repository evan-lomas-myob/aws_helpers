module AwsHelpers
  module RDSCommands
    module Requests
      SnapshotConstructNameRequest = Struct.new(
          :std_out,
          :db_instance_identifier,
          :instance_id,
          :snapshot_name,
          :use_name,
          :instance_polling,
          :snapshot_polling)
    end
  end
end
