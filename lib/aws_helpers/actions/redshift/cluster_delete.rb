require 'aws_helpers/utilities/polling_options'

module AwsHelpers
  module Actions
    module Redshift
      class ClusterDelete
        include AwsHelpers::Utilities::PollingOptions

        def initialize(config, cluster_identifier, options = {})
          @config = config
          @client = config.aws_redshift_client
          @cluster_identifier = cluster_identifier
        end

        def execute
          # TODO:
          response = client.delete_cluster(cluster_identifier: @cluster_identifier)
          response
        end
      end
    end
  end
end