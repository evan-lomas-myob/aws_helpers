require_relative '../common/config'

module AwsHelpers

  module AutoScaling

    class Config < AwsHelpers::Common::Config

      attr_accessor :aws_auto_scaling_client
      attr_accessor :aws_elastic_load_balancing_client

      # @param options [Hash] Optional arguments to pass to the AWS Ruby SDK

      def initialize(options)
        super(options)
      end

      # @return [Aws::AutoScaling::Client]

      def aws_auto_scaling_client
        @aws_auto_scaling_client ||= Aws::AutoScaling::Client.new(options)
      end

      # @return [Aws::ElasticLoadBalancing::Client]

      def aws_elastic_load_balancing_client
        @aws_elastic_load_balancing_client ||= Aws::ElasticLoadBalancing::Client.new(options)
      end

    end

  end
end
