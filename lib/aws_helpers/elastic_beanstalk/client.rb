require 'aws-sdk-core'
require_relative '../common/client'
require_relative 'config'
require_relative 'version'

module AwsHelpers

  module ElasticBeanstalk

    class Client < AwsHelpers::Common::Client

      def initialize(options = {})
        super(AwsHelpers::ElasticBeanstalk::Config.new(options))
      end

      def deploy(application, environment, version)
        ElasticBeanstalk::Version.new(config.aws_elastic_beanstalk_client, config.aws_s3_client, config.aws_iam_client).deploy(application, environment, version)
      end

      def upload(application, version, version_contents, zip_folder)
        ElasticBeanstalk::Version.new(config.aws_elastic_beanstalk_client, config.aws_s3_client, config.aws_iam_client).upload(application, version, version_contents, zip_folder)
      end

    end

  end

end

