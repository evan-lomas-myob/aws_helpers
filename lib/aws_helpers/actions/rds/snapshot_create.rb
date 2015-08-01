module AwsHelpers
  module Actions
    module RDS

      class SnapshotCreate

        def initialize(config, db_instance_id, use_name)
          @config = config
          @db_instance_id = db_instance_id
          @use_name = use_name
        end

        def execute

        end

      end

    end
  end
end