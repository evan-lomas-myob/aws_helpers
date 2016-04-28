require_relative 'client'

require_relative 'kms_commands/requests/get_key_arn_request'
require_relative 'kms_commands/directors/get_key_arn_director'

include AwsHelpers::KMSCommands::Directors
include AwsHelpers::KMSCommands::Requests

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
    def key_arn(alias_name)
      request = GetKeyArnRequest.new(alias_name: alias_name)
      GetKeyArnDirector.new(config).get(request)
    end
  end
end
