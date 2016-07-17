require 'aws_helpers/utilities/polling'

include AwsHelpers::Utilities

module AwsHelpers
  module Actions
    module EC2
      class PollInstanceTagValue
        include AwsHelpers::Utilities::Polling

        def initialize(config, instance_id, tag_key, tag_value, options = {})
          @client = config.aws_ec2_client
          @instance_id = instance_id
          @tag_key = tag_key
          @tag_value = tag_value
          @stdout = options[:stdout] ||= $stdout
          @delay = options[:delay] ||= 15
          @max_attempts = options[:max_attempts] ||= 8
        end

        def execute
          poll(@delay, @max_attempts) do
            instance = @client.describe_instances(instance_ids: [@instance_id]).reservations.map{ |r| r.instances }.flatten.first
            tag = instance.tags.select { |tag| tag.key == @tag_key}
            if tag.length == 0
              @stdout.puts "#{@instance_id} #{@tag_key} not found (expected #{@tag_value})"
              "" == @tag_value
            else
              tag = tag[0]
              @stdout.puts "#{@instance_id} #{@tag_key}=#{tag.value} (expected #{@tag_value})"
              tag.value == @tag_value
            end
          end
        end
      end
    end
  end
end
