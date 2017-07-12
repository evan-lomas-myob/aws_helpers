require 'aws_helpers/utilities/polling'

module AwsHelpers
  module Actions
    module Redshift
      class PollInstanceExists
        include AwsHelpers::Utilities::Polling

        def initialize(config, cluster_identifier, options = {})
          @client = config.aws_redshift_client
          @cluster_identifier = cluster_identifier
          @stdout = options[:stdout] ||= $stdout
          @delay = options[:delay] ||= 15
          @max_attempts = options[:max_attempts] ||= 8
        end

        def execute
          poll(@delay, @max_attempts) do
            begin
              @client.describe_clusters(cluster_identifier: @cluster_identifier)
              true
            rescue Aws::Redshift::Errors::InvalidClusterIDNotFound
              false
            end
          end
        end
      end
    end
  end
end
