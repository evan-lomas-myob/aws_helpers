require 'aws_helpers/utilities/polling_options'

module AwsHelpers
  module Actions
    module Redshift
      class ClusterDelete
        include AwsHelpers::Utilities::PollingOptions

        def initialize(config, cluster_identifier, options = {})
          @config = config
          @cluster_identifier = cluster_identifier
        end

        def execute
          # TODO:
        end
      end
    end
  end
end