module AwsHelpers
  module RDS
    module Requests
      SnapshotCreateRequest = Struct.new(
          :std_out,
          :db_instance_identifier,
          :snapshot_name,
          :use_name,
          :instance_polling,
          :snapshot_polling)
    end
  end
end
