require 'aws_helpers/actions/ec2/instance_run'
require 'aws_helpers/actions/ec2/instance_tag'
require 'aws_helpers/actions/ec2/poll_instance_exists'
require 'aws_helpers/actions/ec2/poll_instance_healthy'
require 'aws_helpers/utilities/polling_options'

module AwsHelpers
  module Actions
    module EC2
      class InstanceCreate
        include AwsHelpers::Utilities::PollingOptions

        def initialize(config, image_id, options)
          @config = config
          @image_id = image_id
          @min_count = options[:min_count] ||= 1
          @max_count = options[:max_count] ||= 1
          @monitoring = options[:monitoring] ||= false
          @app_name = options[:app_name]
          @build_number = options[:build_number]
          stdout = options[:stdout]
          @instance_run_options = create_instance_run_options(stdout, options[:instance_type], options[:additional_opts])
          @instance_exists_polling = create_options(stdout, options[:poll_exists])
          @instance_running_polling = create_options(stdout, options[:poll_running])
        end

        def execute
          instance_id = AwsHelpers::Actions::EC2::EC2InstanceRun.new(@config, @image_id, @min_count, @max_count, @monitoring, @instance_run_options).execute
          AwsHelpers::Actions::EC2::PollInstanceExists.new(@config, instance_id, @instance_exists_polling).execute
          AwsHelpers::Actions::EC2::EC2InstanceTag.new(@config, instance_id, @app_name, @build_number).execute
          AwsHelpers::Actions::EC2::PollInstanceHealthy.new(@config, instance_id, @instance_running_polling).execute
          instance_id
        end

        def create_instance_run_options(stdout, instance_type, additional_opts)
          options = {}
          options[:stdout] = stdout || nil
          options[:instance_type] = instance_type || nil
          options[:additional_opts] = additional_opts || {}
          options
        end
      end
    end
  end
end
