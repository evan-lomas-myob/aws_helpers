require 'aws-sdk-core'
require_relative '../common/client'
require_relative 'version.rb'

module AwsHelpers

  module ElasticBeanstalk

    class Client < AwsHelpers::Common::Client

      def initialize(options = {})
        super(options)
      end

      def deploy(application, environment, version)
        ElasticBeanstalk::Version.new(aws_elastic_beanstalk_client, aws_s3_client, aws_iam_client).deploy(application, environment, version)
      end

      def upload(application, version, version_contents, zip_folder)
        ElasticBeanstalk::Version.new(aws_elastic_beanstalk_client, aws_s3_client, aws_iam_client).upload(application, version, version_contents, zip_folder)
      end

      private

      def aws_elastic_beanstalk_client
        @aws_elastic_beanstalk_client ||= Aws::ElasticBeanstalk::Client.new(@options)
      end

      def aws_s3_client
        @aws_s3_client ||= Aws::S3::Client.new(@options)
      end

      def aws_iam_client
        @aws_iam_client ||= Aws::IAM::Client.new(@options)
      end

    end

  end

end

