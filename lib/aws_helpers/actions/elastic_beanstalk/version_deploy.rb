module AwsHelpers

  module ElasticBeanstalkActions

    class VersionDeploy

      def initialize(config, application, environment, version)
        @config = config
        @application = application
        @environment = environment
        @version = version
      end

      def execute

      end

    end
  end
end
