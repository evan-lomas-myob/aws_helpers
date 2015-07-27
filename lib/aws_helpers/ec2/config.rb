require_relative '../common/config'

module AwsHelpers

  module EC2

    class Config < AwsHelpers::Common::Config

      attr_accessor :aws_ec2_client

      def initialize(options)
        super(options)
      end

      def aws_ec2_client
        @aws_ec2_client ||= Aws::EC2::Client.new(options)
      end

    end

  end
end
