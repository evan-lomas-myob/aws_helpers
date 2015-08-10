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
          response.auto_scaling_groups.find { |auto_scaling_group|
            auto_scaling_group.auto_scaling_group_name == @auto_scaling_group_name
          }.desired_capacity
        end

      end

    end
  end
end

