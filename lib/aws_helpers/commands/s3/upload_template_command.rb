require 'aws_helpers/commands/command'

module AwsHelpers
  module Commands
    module S3
      class UploadTemplateCommand < AwsHelpers::Commands::Command
        def initialize(config, request)
          super(request)
          @client = config.aws_s3_client
        end

        def execute
          stack_name = request.stack_name
          bucket_name = request.bucket_name
          template_json = request.template_json
          return unless stack_name && bucket_name

          put_request = {bucket: bucket_name, key: stack_name, body: template_json}
          put_request.merge!({server_side_encryption: 'AES256'}) if request.bucket_encrypt
          stdout.puts "Uploading #{stack_name} to S3 bucket #{bucket_name}"
          @client.put_object(put_request)
        end
      end
    end
  end
end