require_relative '../common/config'

module AwsHelpers

  module CloudFormation

    class Config < AwsHelpers::Common::Config

      attr_accessor :aws_cloud_formation_client
      attr_accessor :aws_s3_client

      def initialize(options)
        super(options)
      end

      def aws_cloud_formation_client
        @aws_cloud_formation_client = Aws::CloudFormation::Client.new(options)
      end

      def aws_s3_client
        @aws_s3_client = Aws::S3::Client.new(options)
      end

    end

  end
end
