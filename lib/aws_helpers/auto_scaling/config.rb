require_relative '../common/config'

module AwsHelpers

  module AutoScaling

    class Config < AwsHelpers::Common::Config

      attr_accessor :aws_auto_scaling_client
      attr_accessor :aws_elastic_load_balancing_client

      def initialize(options)
        super(options)
      end

      def aws_auto_scaling_client
        @aws_auto_scaling_client ||= Aws::AutoScaling::Client.new(options)
      end

      def aws_elastic_load_balancing_client
        @aws_elastic_load_balancing_client ||= Aws::ElasticLoadBalancing::Client.new(options)
      end

    end

  end
end
