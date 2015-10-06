module AwsHelpers
  module CloudFormation
    class StackErrorEvents

      def initialize(cloud_formation_client, stack_name)
        @cloud_formation_client = cloud_formation_client
        @stack_name = stack_name
      end

      def execute
        events = retrieve_events
        events = filter_post_initiation(events)
        events = filter_failed(events)
        events.each { |event|
          puts "#{event[:timestamp]}, #{event[:resource_status]}, #{event[:logical_resource_id]}, #{event[:resource_status_reason]}"
        }
      end

      private

      def retrieve_events
        events = []
        next_token = nil
        loop do
          response = @cloud_formation_client.describe_stack_events(stack_name: @stack_name, next_token: next_token)
          next_token = response[:next_token]
          events.concat(response[:stack_events])
          break if response[:stack_events].detect { |event| initiation_event?(event) } || next_token.nil?
        end
        events
      end

      def filter_post_initiation(events)
        result = []
        events.each { |event|
          result << event
          break if initiation_event?(event) || complete_event?(event)
        }
        result
      end

      def filter_failed(events)
        events.select { |event|
          [
            CREATE_FAILED,
            DELETE_FAILED,
            UPDATE_FAILED,
            ROLLBACK_FAILED,
            UPDATE_ROLLBACK_FAILED
          ].include?(event[:resource_status])
        }
      end

      def initiation_event?(event)
        [
          CREATE_IN_PROGRESS,
          UPDATE_IN_PROGRESS,
          DELETE_IN_PROGRESS,
        ].include?(event[:resource_status]) &&
          event[:resource_type] == 'AWS::CloudFormation::Stack'
      end

      def complete_event?(event)
        [
          DELETE_COMPLETE,
        ].include?(event[:resource_status]) &&
          event[:resource_type] == 'AWS::CloudFormation::Stack'
      end

    end
  end
end