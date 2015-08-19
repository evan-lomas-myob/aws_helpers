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
          image_id = client.create_image(instance_id: @instance_id, name: @instance_name)
          client.create_tags(resources: [image_id],
                             tags: [{key: 'Name', value: @instance_name}, {key: 'Date', value: @now.to_s}] + @additional_tags
          )
          AwsHelpers::Actions::EC2::PollHealthyImages.new(@config, @instance_id, 1, 60).execute
        end

      end
    end
  end
end