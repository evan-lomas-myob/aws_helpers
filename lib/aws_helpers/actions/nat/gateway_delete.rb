module AwsHelpers
  module Actions
    module NAT

      class GatewayDelete

        def initialize(config, gateway_id)
          @config = config
          @gateway_id = gateway_id
        end

        def execute
          client = @config.aws_ec2_client
          client.delete_nat_gateway(nat_gateway_id: @gateway_id)
        #   instance_id = AwsHelpers::Actions::EC2::EC2InstanceRun.new(@config, @image_id, @min_count, @max_count, @monitoring, @instance_run_options).execute
        #   AwsHelpers::Actions::EC2::PollInstanceExists.new(instance_id, @instance_exists_polling).execute
        #   AwsHelpers::Actions::EC2::EC2InstanceTag.new(@config, instance_id, @app_name, @build_number).execute
        #   AwsHelpers::Actions::EC2::PollInstanceHealthy.new(@config, instance_id, @instance_running_polling).execute
        #   instance_id
        end

        # def create_instance_run_options(stdout, instance_type, additional_opts)
        #   options = {}
        #   options[:stdout] = stdout || nil
        #   options[:instance_type] = instance_type || nil
        #   options[:additional_opts] = additional_opts || {}
        #   options
        # end

        # def create_polling_options(stdout, polling)
        #   options = {}
        #   options[:stdout] = stdout if stdout
        #   if polling
        #     max_attempts = polling[:max_attempts]
        #     delay = polling[:delay]
        #     options[:max_attempts] = max_attempts if max_attempts
        #     options[:delay] = delay if delay
        #   end
        #   options
        # end

      end
    end
  end
end