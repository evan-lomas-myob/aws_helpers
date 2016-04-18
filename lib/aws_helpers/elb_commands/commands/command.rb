module AwsHelpers
  module ELBCommands
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
