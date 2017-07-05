require 'aws_helpers/utilities/polling_options'

module AwsHelpers
  module Actions
    module Redshift
      class ClusterDelete
        include AwsHelpers::Utilities::PollingOptions

        def initialize(config, stack_name, options = {})
          @config = config
        end

        def execute
          # TODO:
        end
      end
    end
  end
end