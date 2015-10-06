require_relative 'client'
require_relative 'actions/auto_scaling/retrieve_desired_capacity'
require_relative 'actions/auto_scaling/update_desired_capacity'

include AwsHelpers::Actions::AutoScaling

module AwsHelpers

  class AutoScaling < AwsHelpers::Client

    # AutoScaling utilities for retrieving and updating
    # @param options [Hash] Optional Arguments to include when calling the AWS SDK
    def initialize(options = {})
      super(options)
    end

    # @param auto_scaling_group_name [String] The group name of the Auto scaling client
    # @return [Integer] The desired capacity of an auto scaling group
    def retrieve_desired_capacity(auto_scaling_group_name)
      RetrieveDesiredCapacity.new(config, auto_scaling_group_name).execute
    end

    # Changes the desired capacity of an auto scaling group.
    #
    # - Once changed will poll the group until the all servers reach an InService lifecycle status.
    # - If load balancers are attached to the group, will also poll them until they have a status of InService
    # @param auto_scaling_group_name [String] The group name of the Auto scaling client
    # @param desired_capacity [Integer] The capacity level of the auto scaling group
    # @param [Hash] options Optional parameters that can be overridden.
    # @option options [IO] :stdout Override $stdout when logging output
    # @option options [Hash{Symbol => Integer}] :auto_scaling_polling Override auto scaling default polling
    #
    #   defaults:
    #
    #   ```
    #   {
    #     :max_attempts => 20,
    #     :delay => 15 # seconds
    #   }
    #   ```
    # @option options [Hash{Symbol => Integer}] :load_balancer_polling Override load balancer default polling
    #
    #   defaults:
    #
    #   ```
    #   {
    #     :max_attempts => 20,
    #     :delay => 15 # seconds
    #   }
    #   ```
    def update_desired_capacity(auto_scaling_group_name, desired_capacity, options = {})
      UpdateDesiredCapacity.new(config, auto_scaling_group_name, desired_capacity, options).execute
    end

  end

end



