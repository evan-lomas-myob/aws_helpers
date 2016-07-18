module AwsHelpers
  module Actions
    module AutoScaling
      class ResumeAlarmProcess

        def initialize(config, auto_scaling_group_name, options)
          @config = config
          @auto_scaling_group_name = auto_scaling_group_name
          @stdout = options[:stdout] ||= $stdout

        end

        def execute
          client = @config.aws_auto_scaling_client
          client.resume_processes( auto_scaling_group_name: @auto_scaling_group_name,
              scaling_processes: ['AlarmNotification']
          )
        end
      end
    end
  end
end
