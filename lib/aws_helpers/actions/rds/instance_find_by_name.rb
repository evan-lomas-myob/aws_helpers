module AwsHelpers
  module Actions
    module RDS
      class InstanceFindByName
        def initialize(config, db_name)
          @config = config
          @db_name = db_name
        end

        def execute
          @config.aws_rds_client.describe_db_instances.db_instances.find do |instance|
            instance.db_name == @db_name
          end
        end
      end
    end
  end
end
