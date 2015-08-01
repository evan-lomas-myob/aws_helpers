module AwsHelpers

  module AutoScalingActions

    class UpdateDesiredCapacity

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