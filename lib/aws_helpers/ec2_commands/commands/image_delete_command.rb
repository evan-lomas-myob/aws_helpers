require 'aws_helpers/ec2_commands/commands/command'

module AwsHelpers
  module EC2Commands
    module Commands
      class ImageDeleteCommand < AwsHelpers::EC2Commands::Commands::Command
        def initialize(config, request)
          @client = config.aws_ec2_client
          @request = request
        end

        def execute
          @client.deregister_image(image_id: @request.image_id)
        end
      end
    end
  end
end
