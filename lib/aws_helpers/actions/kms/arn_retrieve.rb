module AwsHelpers
  module Actions
    module KMS

      class ArnRetrieve

        def initialize(config, alias_name)
          @client = config.aws_kms_client
          @alias_name = alias_name
        end

        def execute
          alias_entry = @client.list_aliases.aliases.find { |alias_entry|
            alias_entry.alias_name == "alias/#{@alias_name}"
          }
          alias_entry.alias_arn if alias_entry
        end

      end

    end
  end
end