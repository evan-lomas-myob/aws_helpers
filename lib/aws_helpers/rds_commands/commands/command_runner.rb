module AwsHelpers
  module RDSCommands
    module Commands
      module CommandRunner
        private

        def execute_commands
          @commands.each(&:execute)
        end
      end
    end
  end
end
