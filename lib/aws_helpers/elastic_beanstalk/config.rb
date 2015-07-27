require_relative '../common/config'

module AwsHelpers

  module ElasticBeanstalk

    class Config < AwsHelpers::Common::Config

      attr_accessor :aws_elastic_beanstalk_client
      attr_accessor :aws_s3_client
      attr_accessor :aws_iam_client

      def initialize(options)
        super(options)
      end

      def aws_elastic_beanstalk_client
        @aws_elastic_beanstalk_client ||= Aws::ElasticBeanstalk::Client.new(options)
      end

      def aws_s3_client
        @aws_s3_client ||= Aws::S3::Client.new(options)
      end

      def aws_iam_client
        @aws_iam_client ||= Aws::IAM::Client.new(options)
      end

    end

  end
end
