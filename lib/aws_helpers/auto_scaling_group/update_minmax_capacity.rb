module AwsHelpers
  module AutoScalingGroup
    class UpdateMinMaxCapacity

      def initialize(auto_scaling_client, auto_scaling_group_name, min_size, max_size)
        @auto_scaling_client = auto_scaling_client
        @auto_scaling_group_name = auto_scaling_group_name
        @min_size = min_size
        @max_size = max_size
      end

      def execute
        @auto_scaling_client.update_auto_scaling_group({
          auto_scaling_group_name: @auto_scaling_group_name,
          min_size: @min_size,
          max_size: @max_size
        })
      end

    end
  end
end
