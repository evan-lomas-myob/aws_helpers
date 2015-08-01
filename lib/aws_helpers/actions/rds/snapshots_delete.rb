module AwsHelpers
  module Actions
    module RDS

      class SnapshotsDelete

        def initialize(config, db_instance_id, days, months, years)
          @config = config
          @db_instance_id = db_instance_id
          @days = days
          @months = months
          @years = years
        end

        def execute

        end

      end

    end
  end
end