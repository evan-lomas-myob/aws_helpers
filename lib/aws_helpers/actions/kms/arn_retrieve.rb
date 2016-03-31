module AwsHelpers
  module Actions
    module KMS
      class ArnRetrieve
        def initialize(config, alias_name, options = {})
          @client = config.aws_kms_client
          @alias_name = alias_name
          @use_key_metadata_arn = options[:use_key_metadata_arn]
        end

        def execute
          alias_entry = @client.list_aliases.aliases.find do |entry|
            entry.alias_name == "alias/#{@alias_name}"
          end
          if alias_entry
            return @client.describe_key(key_id: alias_entry.target_key_id).key_metadata.arn if @use_key_metadata_arn
            alias_entry.alias_arn
          end
        end
      end
    end
  end
end
