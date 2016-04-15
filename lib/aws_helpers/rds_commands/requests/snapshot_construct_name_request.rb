module AwsHelpers
  module RDSCommands
    module Requests
      SnapshotConstructNameRequest = Struct.new(
          :std_out,
          :db_instance_id,
          :instance_id,
          :image_id,
          :image_name,
          :snapshot_name,
          :use_name,
          :instance_polling,
          :snapshot_polling)
    end
  end
end
