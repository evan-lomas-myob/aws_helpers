require 'aws_helpers/actions/rds/instance_state'
require 'aws_helpers/utilities/polling'

module AwsHelpers
  module RDS
    module Commands
      class Command

        attr_accessor :std_out

        def std_out
          @std_out ||= $stdout
        end

        def execute
        end

      end
    end
  end
end
