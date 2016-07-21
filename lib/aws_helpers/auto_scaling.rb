require_relative 'client'
require_relative 'actions/auto_scaling/retrieve_desired_capacity'
require_relative 'actions/auto_scaling/update_desired_capacity'
require_relative 'actions/auto_scaling/retrieve_current_instances'
require_relative 'actions/auto_scaling/resume_alarm_process'
require_relative 'actions/auto_scaling/suspend_alarm_process'

include AwsHelpers::Actions::AutoScaling

module AwsHelpers
  class AutoScaling < AwsHelpers::Client
    # AutoScaling utilities for retrieving and updating
    #
    # @param options [Hash] Optional arguments to include when calling the AWS SDK. These arguments will
    #   affect all clients used by this helper. See the {http://docs.aws.amazon.com/sdkforruby/api/Aws/AutoScaling/Client.html#initialize-instance_method AWS documentation}
    #   for a list of AutoScaling-specific client options.
    #
    # @example Initialise AutoScaling Client
    #    client = AwsHelpers::AutoScaling.new
    #
    # @return [AwsHelpers::AutoScaling]
    #
    def initialize(options = {})
      super(options)
    end

    # Return the desired capacity for an AutoScaling Group
    #
    # @param auto_scaling_group_name [String] The AutoScaling group name
    #
    # @example Retrieve the desired capacity
    #    desired_capacity = AwsHelpers::AutoScaling.new.retrieve_desired_capacity('MyASG')
    #
    # @return [Integer] The desired capacity of the auto scaling group
    #
    def retrieve_desired_capacity(auto_scaling_group_name)
      RetrieveDesiredCapacity.new(config, auto_scaling_group_name).execute
    end

    # Resume alarm notifications for the specified auto scaling group
    #
    # @param auto_scaling_group_name [String] The AutoScaling group name
    #
    # @example Retrieve the desired capacity
    #    AwsHelpers::AutoScaling.new.resume_alarm_process('MyASG')
    #
    # @return [] Empty array
    #
    def resume_alarm_process(auto_scaling_group_name, options = {})
      ResumeAlarmProcess.new(config, auto_scaling_group_name, options).execute
    end

    # Suspends alarm notifications for the specified auto scaling group
    #
    # @param auto_scaling_group_name [String] The AutoScaling group name
    #
    # @example Retrieve the desired capacity
    #    AwsHelpers::AutoScaling.new.suspend_alarm_process('MyASG')
    #
    # @return [] Empty array
    #
    def suspend_alarm_process(auto_scaling_group_name, options = {})
      SuspendAlarmProcess.new(config, auto_scaling_group_name, options).execute
    end

    # Changes the desired capacity of an auto scaling group.
    #
    # - Once changed will poll the group until the all servers reach an InService lifecycle status.
    # - If load balancers are attached to the group, will also poll them until they have a status of InService
    #
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
    #
    # @example Change the desired capacity
    #   AwsHelpers::AutoScaling.new.update_desired_capacity('Auto-Scaling-Group',2)
    #
    # @return [Array] Load Balancers configured for this Auto Scaling Group
    #
    def update_desired_capacity(auto_scaling_group_name, desired_capacity, options = {})
      UpdateDesiredCapacity.new(config, auto_scaling_group_name, desired_capacity, options).execute
    end

    # Gets the instances belonging to an auto scaling group.
    #
    # @param auto_scaling_group_name [String] The AutoScaling group name
    #
    # @example List the instances associated with an ASG
    #   AwsHelpers::AutoScaling.new.retrieve_current_instances('MyASG')
    #
    # @return [Array<Aws::EC2::Types::Instance>] Array of {http://docs.aws.amazon.com/sdkforruby/api/Aws/EC2/Instance.html Instance}
    #
    def retrieve_current_instances(auto_scaling_group_name)
      RetrieveCurrentInstances.new(config, auto_scaling_group_name).execute
    end
  end
end
