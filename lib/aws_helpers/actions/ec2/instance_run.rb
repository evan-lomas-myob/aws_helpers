module AwsHelpers
  module Actions
    module EC2

      class EC2InstanceRun

        def initialize(config, image_id, min_count, max_count, monitoring, options = {})
          @config = config
          @image_id = image_id
          @min_count = min_count
          @max_count = max_count
          @monitoring = {enabled: monitoring}
          @instance_type = options[:instance_type] || 't2.micro'
          @stdout = options[:stdout] || $stdout
        end

        def execute
          @stdout.puts("Starting Instance with #{@image_id}")
          client = @config.aws_ec2_client
          response = client.run_instances(image_id: @image_id, min_count: @min_count, max_count: @max_count, instance_type: @instance_type, monitoring: @monitoring)
          response.instances.first.instance_id
        end

      end
    end
  end
end
