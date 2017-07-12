require 'base64'
require 'aws_helpers/utilities/polling'

include AwsHelpers::Utilities

module AwsHelpers
  module Actions
    module Redshift
      class PollInstanceHealthy
        include AwsHelpers::Utilities::Polling

        def initialize(config, cluster_identifier, options = {})
          @config = config
          @client = config.aws_redshift_client
          @cluster_identifier = cluster_identifier
          @stdout = options[:stdout] ||= $stdout
          @delay = options[:delay] ||= 60
          @max_attempts = options[:max_attempts] ||= 60
        end

        def execute
          poll(@delay, @max_attempts) do
            puts resp.clusters[0].cluster_status
            resp = @client.describe_clusters(cluster_identifier: @cluster_identifier)
            resp.clusters[0].cluster_status == 'available'
          end
        end
      end
    end
  end
end
