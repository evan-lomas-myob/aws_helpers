require_relative '../common/config'

module AwsHelpers

  module ElasticLoadBalancing

    class Config < AwsHelpers::Common::Config

      attr_accessor :aws_elastic_load_balancing_client

      def initialize(options)
        super(options)
      end

      def aws_elastic_load_balancing_client
        @aws_elastic_load_balancing_client ||= Aws::ElasticLoadBalancing::Client.new(options)
      end

    end

  end
end
