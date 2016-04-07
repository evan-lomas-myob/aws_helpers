require 'aws_helpers/utilities/polling'

module AwsHelpers
  module EC2Commands
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
