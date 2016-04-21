require 'aws_helpers/command'

module AwsHelpers
  module KMSCommands
    module Commands
      class GetKeyArnCommand < AwsHelpers::Command
        def initialize(config, request)
          @client = config.aws_kms_client
          @request = request
        end

        def execute
          alias_entry = @client.list_aliases.aliases.find do |entry|
            entry.alias_name == "alias/#{@request.alias_name}"
          end
          arn = nil
          if alias_entry
            if @request.use_key_metadata_arn
              arn = @client.describe_key(key_id: alias_entry.target_key_id).key_metadata.arn
            else
              arn = alias_entry.alias_arn
            end
          end
          @request.key_arn = arn
        end
      end
    end
  end
end
