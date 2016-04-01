module AwsHelpers
  module Actions
    module AutoScaling
      class RetrieveDesiredCapacity
        def initialize(config, auto_scaling_group_name)
          @config = config
          @auto_scaling_group_name = auto_scaling_group_name
        end

        def execute
          client = @config.aws_auto_scaling_client
          response = client.describe_auto_scaling_groups(auto_scaling_group_names: [@auto_scaling_group_name])
          response.auto_scaling_groups.find do |auto_scaling_group|
            auto_scaling_group.auto_scaling_group_name == @auto_scaling_group_name
          end.desired_capacity unless response.auto_scaling_groups.empty?
        end
      end
    end
  end
end
