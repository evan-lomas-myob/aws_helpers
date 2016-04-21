module AwsHelpers
  module CommandRunner
    private

    def execute_commands
      @commands.each { |c| c.execute }
    end
  end
end
