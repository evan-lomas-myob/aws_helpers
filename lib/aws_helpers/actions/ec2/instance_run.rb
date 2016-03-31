module AwsHelpers
  module Actions
    module EC2
      class EC2InstanceRun
        def initialize(config, image_id, min_count, max_count, monitoring, options = {})
          @config = config
          @image_id = image_id
          @min_count = min_count
          @max_count = max_count
          @instance_type = options[:instance_type] || 't2.micro'
          @additional_opts = options[:additional_opts] || {}
          @monitoring = { enabled: monitoring }
          @stdout = options[:stdout] || $stdout
        end

        def execute
          @stdout.puts("Starting Instance with #{@image_id}")
          client = @config.aws_ec2_client
          run_opts = { image_id: @image_id, min_count: @min_count, max_count: @max_count, instance_type: @instance_type, monitoring: @monitoring }.merge(@additional_opts)
          response = client.run_instances(run_opts)
          response.instances.first.instance_id
        end
      end
    end
  end
end
