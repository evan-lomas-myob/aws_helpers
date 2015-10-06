module AwsHelpers
  module AutoScalingGroup
    class DrainInstances

      def initialize(auto_scaling_client, auto_scaling_group_name)
        @auto_scaling_client = auto_scaling_client
        @auto_scaling_group_name = auto_scaling_group_name
      end

      def execute
        # The desired capacity of the group will be set to zero as a result
        # of setting the maximum to zero.
        @auto_scaling_client.update_auto_scaling_group({
          auto_scaling_group_name: @auto_scaling_group_name,
          min_size: 0,
          max_size: 0
        })
      end

    end
  end
end
