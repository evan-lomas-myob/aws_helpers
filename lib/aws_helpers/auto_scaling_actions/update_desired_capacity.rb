module AwsHelpers

  module AutoScalingActions

    class UpdateDesiredCapacity

      # @param config [AwsHelpers::AutoScaling::Config] config object with access methods to aws_auto_scaling_client and aws_elastic_load_balancing_client
      # @param auto_scaling_group_name [String] Name given to auto scaling group
      # @param desired_capacity [Integer] Number of desired EC2 instances in the scaling group
      # @param timeout [Integer] Time in seconds to timeout

      def initialize(config, auto_scaling_group_name, desired_capacity, timeout)

        @config = config
        @auto_scaling_group_name = auto_scaling_group_name
        @desired_capacity = desired_capacity
        @timeout = timeout

      end

      def execute

      end

    end
  end
end