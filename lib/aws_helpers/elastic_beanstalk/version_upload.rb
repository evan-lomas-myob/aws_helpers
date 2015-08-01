module AwsHelpers

  module ElasticBeanstalkActions

    class VersionUpload

      # @param config [AwsHelpers::ElasticBeanstalk::Config] access method to Aws::ElasticBeanstalk::Client, Aws::S3::Client and Aws::IAM::Client
      # @param upload_parameters [String] Upload version parameters
      def initialize(config, upload_parameters)
        @config = config
        @upload_parameters = upload_parameters
      end

      def execute

      end

    end
  end
end
