require 'aws_helpers/utilities/wait_helper'

include AwsHelpers::Utilities

module AwsHelpers
  module Actions
    module EC2

      class PollHealthyImages

        # Constant        Response          Code
        # RUNNING       = 'running'       # 0
        # PENDING       = 'pending'       # 16
        # SHUTTING_DOWN = 'shutting-down' # 32
        # TERMINATED    = 'terminated'    # 48
        # STOPPING      = 'stopping'      # 64
        # STOPPED       = 'stopped'       # 80

        def initialize(config, instance_id, expected_number, timeout, stdout = $stdout)
          @config = config
          @instance_id = instance_id
          @expected_number = expected_number
          @timeout = timeout
          @stdout = stdout
        end

        def execute
          #TODO: Is expected_number actually needed?
          client = @config.aws_ec2_client
          WaitHelper.wait(client, @timeout, :instance_status_ok, instance_id: [@instance_id]) { |_attempts, response|
            response.instance_statuses.each { |instance_status|
              instance_state = instance_status.instance_state.name
              @stdout.puts "Image State is #{instance_state}"
            }
          }
        end
      end
    end
  end
end

