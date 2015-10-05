module AwsHelpers
  module AutoScalingGroup
    class RetrieveGroupConfiguration

      def initialize(auto_scaling_client, auto_scaling_group_name)
        @auto_scaling_client = auto_scaling_client
        @auto_scaling_group_name = auto_scaling_group_name
      end

      # Returns the autoscaling group configuration. See the following URL for a description of the output:
      # http://docs.aws.amazon.com/sdkforruby/api/Aws/AutoScaling/Client.html#describe_auto_scaling_groups-instance_method
      def execute
        auto_scaling_groups = @auto_scaling_client.describe_auto_scaling_groups(:auto_scaling_group_names => [@auto_scaling_group_name])[:auto_scaling_groups]
        auto_scaling_groups.detect { |auto_scaling_group| auto_scaling_group[:auto_scaling_group_name] == @auto_scaling_group_name }
      end

    end
  end
end
