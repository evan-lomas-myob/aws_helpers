require_relative 'client'
require_relative 'actions/redshift/cluster_create'
require_relative 'actions/redshift/cluster_delete'

include AwsHelpers::Actions::Redshift

module AwsHelpers
  class Redshift < AwsHelpers::Client
    # Utilities for Redshift creation, deletion and search of Redshift images
    #
    # @param options [Hash] Optional arguments to include when calling the AWS SDK. These arguments will
    #   affect all clients used by this helper. See the {http://docs.aws.amazon.com/sdkforruby/api/Aws/Redshift/Client.html#initialize-instance_method AWS documentation}
    #   for a list of redshift client options.
    # @example Initialise Redshift Client
    #    aws = AwsHelpers::Redshift.new
    # @return [AwsHelpers::Redshift]
    #
    def initialize(options = {})
      super(options)
    end

    # Create an AMI using an existing instance
    #
    # @param cluster_type [String] 
    # @param cluster_identifier [String] Id of the Redshift Instance
    # @param [Hash] options Optional parameters that can be overridden.
    # @option options [Array] :additional_tags additional tags to put into the image
    #
    #   ```
    #   [
    #     { key: 'Tag Key', value: 'Tag Value' }
    #   ]
    #   ```
    # @option options [Time] :now override the current time
    # @option options [IO] :stdout ($stdout) override $stdout when logging output
    # @option options [Hash] :poll_image_available override image available polling
    #
    #   defaults:
    #
    #   ```
    #   {
    #     :max_attempts => 20,
    #     :delay => 30 # seconds
    #   }
    #   ```
    # @example Create an Image
    #   AwsHelpers::Redshift.new.image_create('i-12345678','New Image Name')
    #
    # @return [String] the image id
    #
    def cluster_create(cluster_type, cluster_identifier, options = {})
      # node_type
      ClusterCreate.new(config, cluster_type, cluster_identifier, options).execute
    end

    # De-register an AMI image and its associated snapshots
    #
    # @param cluster_identifier [String] Id of the Redshift Instance
    # @param [Hash] options Optional parameters that can be overridden.
    # @option options [IO] :stdout ($stdout) override $stdout when logging output
    #
    # @example De-register an Image
    #   AwsHelpers::Redshift.new.image_delete('ami-12345678')
    #
    # @return [Seahorse::Client::Response] An empty response
    #
    def cluster_delete(cluster_identifier, options = {})
      ClusterDelete.new(config, cluster_identifier, options).execute
    end
  end
end