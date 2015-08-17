require 'aws_helpers/cloud_formation'
require 'aws_helpers/actions/cloud_formation/stack_retrieve_events'
require 'aws_helpers/actions/cloud_formation/stack_events_filter_post_initiation'
require 'aws_helpers/actions/cloud_formation/stack_events_filter_failed'

module AwsHelpers
  module Actions
    module CloudFormation

      class StackErrorEvents

        def initialize(config, stack_name, stdout)
          @config = config
          @stack_name = stack_name
          @stdout = stdout
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
