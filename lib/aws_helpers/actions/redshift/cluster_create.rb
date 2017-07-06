require 'aws_helpers/actions/redshift/poll_instance_exists'
require 'aws_helpers/actions/redshift/instance_tag'
require 'aws_helpers/actions/redshift/poll_snapshot_healthy'
require 'aws_helpers/utilities/polling_options'

module AwsHelpers
  module Actions
    module Redshift
      class ClusterCreate
        include AwsHelpers::Utilities::PollingOptions

        def initialize(config, cluster_type, cluster_identifier, options)
          @config = config
          @cluster_type = cluster_type
          @cluster_identifier = cluster_identifier
          @db_name = options[:db_name] ||= $db_name
          @master_username = options[:master_username] ||= $master_username
          @master_user_password = options[:master_user_password] ||= $master_user_password
          @node_type = options[:node_type] ||= $node_type
        end

        def execute
          # TODO:
          # AWS::Redshift::Cluster
          client = @config.aws_redshift_client

          client.create_cluster(
            cluster_type: @cluster_type,
            cluster_identifier: @cluster_identifier,
            db_name: @db_name,
            master_username: @master_username,
            master_user_password: @master_user_password,
            node_type: @node_type
          )

          AwsHelpers::Actions::Redshift::PollInstanceExists.new(@config, instance_id, @instance_exists_polling).execute
          AwsHelpers::Actions::Redshift::RedshiftInstanceTag.new(@config, instance_id, @app_name, @build_number).execute
          AwsHelpers::Actions::Redshift::PollInstanceHealthy.new(@config, instance_id, @instance_running_polling).execute
        end

      end
    end
  end
end