module AwsHelpers
  module Actions
    module EC2

      class ImageCreate

        def initialize(config, instance_id, instance_name, additional_tags = [], now = Time.now, stdout = $stdout)
          @config = config
          @instance_id = instance_id
          @instance_name = instance_name
          @additional_tags = additional_tags
          @now = now
          @stdout = stdout
        end

        def execute
          client = @config.aws_ec2_client
          check_image_state(client, @instance_id)
          image_id = client.create_image(instance_id: @instance_id, name: @instance_name)
          client.create_tags(resources: [image_id],
                             tags: [{key: 'Name', value: @instance_name}, {key: 'Date', value: @now.to_s}] + @additional_tags
          )
          end

        def check_image_state(client, instance_id)
          states = %w(running stopped)
          image_status = client.describe_instance_status(instance_ids: [instance_id]).instance_statuses.first.instance_state.name
          raise "AMI creation from #{instance_id} failed. State is #{image_status}" unless states.include?(image_status)
        end

      end
    end
  end
end