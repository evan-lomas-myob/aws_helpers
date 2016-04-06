module AwsHelpers
  module RDS
    module Commands
      module CommandRunner

        private

        def execute_commands
          @commands.each { |command| command.execute }
        end

      end
    end
  end
end
