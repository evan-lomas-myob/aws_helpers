module AwsHelpers
  module NATCommands
    module Commands
      module CommandRunner
        private

        def execute_commands
          @commands.each { |c| c.execute }
        end
      end
    end
  end
end
