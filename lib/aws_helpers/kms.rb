require_relative 'client'
require_relative 'actions/kms/arn_retrieve'

module AwsHelpers
  class KMS < AwsHelpers::Client
    # Utilities for KMS
    #
    # @param options [Hash] Optional arguments to include when calling the AWS SDK. These arguments will
    #   affect all clients used by this helper. See the {http://docs.aws.amazon.com/sdkforruby/api/Aws/KMS/Client.html#initialize-instance_method AWS documentation}
    #   for a list of KMS client options.
    #
    # @example Create a KMS Client
    #   AwsHelpers.KMS.new
    #
    # @return [AwsHelpers::KMS]
    #
    def initialize(options = {})
      super(options)
    end

    # Returns the KMS key arn given an alias
    #
    # @param [String] alias_name
    #
    # @example Get the KMS ARN
    #   AwsHelpers::KMS.new.key_arn('alias-name')
    #
    # @return [String,nil] the kms arn
    #
    def key_arn(alias_name, options = {})
      AwsHelpers::Actions::KMS::ArnRetrieve.new(config, alias_name, options).execute
    end
  end
end
