module AwsHelpers

  module ElasticBeanstalkActions

    class VersionDeploy

      # @param config [AwsHelpers::ElasticBeanstalk::Config] access method to Aws::ElasticBeanstalk::Client, Aws::S3::Client and Aws::IAM::Client
      # @param application [String] Name given to the AWS ElasticBeanstalk application
      # @param environment [String] Environment target of the app (dev, test - etc)
      # @param version [String] Version of the deployed application
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
