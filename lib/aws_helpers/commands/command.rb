module AwsHelpers
  module Commands
    class Command

      attr_accessor :stdout
      attr_accessor :request

      def initialize(request)
        @request = request
        @stdout = request.stdout if request.respond_to? :stdout
      end

      def stdout
        @stdout ||= $stdout
      end

      def execute
      end
    end
  end
end