module AwsHelpers

  module AutoScalingActions

    class RetrieveDesiredCapacity

      # @param config [AwsHelpers::AutoScaling::Config] config object with access methods to aws_auto_scaling_client and aws_elastic_load_balancing_client
      # @param auto_scaling_group_name [String] Name given to auto scaling group

    def initialize(config, auto_scaling_group_name)

        @config = config
        @auto_scaling_group_name = auto_scaling_group_name

      end

      def execute

      end

    end
  end
end
