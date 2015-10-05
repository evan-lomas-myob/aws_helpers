module AwsHelpers
  module AutoScalingGroup
    class ResumeAlarmProcess

      def initialize(auto_scaling_client, auto_scaling_group_name)
        @auto_scaling_client = auto_scaling_client
        @auto_scaling_group_name = auto_scaling_group_name
      end

      def execute
        @auto_scaling_client.resume_processes(
          auto_scaling_group_name: @auto_scaling_group_name,
          scaling_processes: ['AlarmNotification']
        )
      end

    end
  end
end
