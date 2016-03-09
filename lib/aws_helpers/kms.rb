require_relative 'client'
require_relative 'actions/kms/arn_retrieve'

module AwsHelpers

  class KMS < AwsHelpers::Client

    # Utilities for KMS
    # @param options [Hash] Optional Arguments to include when calling the AWS SDK
    def initialize(options = {})
      super(options)
    end

    # Returns the KMS key arn given an alias
    # @param [String] alias_name
    # @return [String] the kms arn
    def key_arn(alias_name, options={})
      AwsHelpers::Actions::KMS::ArnRetrieve.new(config, alias_name, options).execute
    end

  end

end


