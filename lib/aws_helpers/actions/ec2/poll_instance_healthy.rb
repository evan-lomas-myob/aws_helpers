require 'base64'
require 'aws_helpers/utilities/polling'

include AwsHelpers::Utilities

module AwsHelpers
  module Actions
    module EC2

      class PollInstanceHealthy

        include AwsHelpers::Utilities::Polling

        def initialize(instance_id, options = {})
          @instance_id = instance_id
          @stdout = options[:stdout] || $stdout
          @delay = options[:delay] || 15
          @max_attempts = options[:max_attempts] || 8
        end

        def execute
          poll(@delay, @max_attempts) {
            client = Aws::EC2::Instance.new(@instance_id)
            current_state = client.state.name
            @stdout.print "Instance State is #{current_state}"

            @retain_line ||= ''
            ready = false

            if client.platform == 'windows' && current_state == 'running'
              @stdout.print '. Wait for Windows to be Ready'
              output = client.console_output.output
              unless output.nil?
                output = Base64.decode64(output)
                line = output.split("\n").grep(/Windows is Ready to use/)
                # The aws console can initially output a pre-reboot console (really? yes - really)
                # I'm working around this by checking twice with a delay
                # Confirm that both times, the same message (including timestamp) appear
                line == @retain_line ? ready = true : @retain_line = line
              end
            else
              ready = true
            end

            @stdout.print ".\n"
            current_state == 'running' && ready
          }
        end

      end
    end
  end
end

