require 'aws_helpers/actions/redshift/poll_instance_exists'
require 'aws_helpers/actions/redshift/instance_tag'
require 'aws_helpers/actions/redshift/poll_instance_healthy'
require 'aws_helpers/utilities/polling_options'

module AwsHelpers
  module Actions
    module Redshift
      class ClusterCreate
        include AwsHelpers::Utilities::PollingOptions

        def initialize(config, cluster_type, cluster_identifier, master_username, master_user_password, options)
          @config = config
          @client = config.aws_redshift_client
          @cluster_type = cluster_type
          @cluster_identifier = cluster_identifier
          @master_username = master_username
          @master_user_password = master_user_password
          @db_name = options[:db_name] ||= $db_name
          @node_type = options[:node_type] ||= $node_type
          @vpc_security_group_ids = options[:vpc_security_group_ids] ||= $vpc_security_group_ids
        end

        def execute
          # create_cluster_parameter_group
          response = @client.create_cluster(
            cluster_type: @cluster_type,
            cluster_identifier: @cluster_identifier,
            db_name: @db_name,
            master_username: @master_username,
            master_user_password: @master_user_password,
            node_type: @node_type,
            vpc_security_group_ids: @vpc_security_group_ids
          )

          AwsHelpers::Actions::Redshift::PollInstanceExists.new(@config, instance_id, @instance_exists_polling).execute
          AwsHelpers::Actions::Redshift::RedshiftInstanceTag.new(@config, instance_id, @app_name, @build_number).execute
          AwsHelpers::Actions::Redshift::PollInstanceHealthy.new(@config, instance_id, @instance_running_polling).execute
          response
        end

      end
    end
  end
end