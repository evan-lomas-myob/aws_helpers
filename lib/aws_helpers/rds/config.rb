require_relative '../common/config'

module AwsHelpers

  module RDS

    class Config < AwsHelpers::Common::Config

      attr_accessor :aws_rds_client
      attr_accessor :aws_iam_client

      def initialize(options)
        super(options)
      end

      def aws_rds_client
        @aws_rds_client ||= Aws::RDS::Client.new(options)
      end

      def aws_iam_client
        @aws_iam_client ||= Aws::IAM::Client.new(options)
      end

    end

  end
end
