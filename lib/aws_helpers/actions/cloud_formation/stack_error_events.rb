require 'aws_helpers/actions/cloud_formation/stack_error_events'
require 'aws_helpers/actions/cloud_formation/stack_events_filter_failed'
require 'aws_helpers/actions/cloud_formation/stack_events_filter_post_initiation'

module AwsHelpers
  module Actions
    module CloudFormation

      class StackErrorEvents

        def initialize(stdout,config, stack_name)
          @stdout = stdout
          @config = config
          @stack_name = stack_name
        end

        def execute
          events = AwsHelpers::Actions::CloudFormation::StackRetrieveEvents.new(@config, @stack_name).execute
          events = AwsHelpers::Actions::CloudFormation::StackEventsFilterPostInitiation.new(events).execute
          events = AwsHelpers::Actions::CloudFormation::StackEventsFilterFailed.new(events).execute

          events.each { |event|
            @stdout.puts "#{event.timestamp}, #{event.resource_status}, #{event.logical_resource_id}, #{event.resource_status_reason}"
          }

        end

      end

    end
  end
end
