module AwsHelpers

  module ElasticBeanstalk

    class Version

      def initialize(aws_elastic_beanstalk_client, aws_s3_client, aws_iam_client)

      end

      def deploy(application, environment, version)

      end

      def upload(application, version, version_contents, zip_folder)

      end

    end
  end
end
