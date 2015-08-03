require_relative 'client'
require_relative 'actions/elastic_beanstalk/version_deploy'
require_relative 'actions/elastic_beanstalk/version_upload'

include AwsHelpers::Actions::ElasticBeanstalk

module AwsHelpers

  class ElasticBeanstalk < AwsHelpers::Client

    # Utilities for ElasticBeanstalk deployment
    # @param options [Hash] Optional Arguments to include when calling the AWS SDK
    # @return [AwsHelpers::Config] A Config object with options initialized
  def initialize(options = {})
      super(options)
    end

    # @param application [String] Name given to the AWS ElasticBeanstalk application
    # @param environment [String] Environment target of the app (dev, test - etc)
    # @param version [String] Version of the deployed application
    def deploy(application:, environment:, version:)
      VersionDeploy.new(config, application, environment, version).execute
    end

    # @param upload_parameters [String] Upload version parameters
    def upload(upload_parameters:)
      VersionUpload.new(config, upload_parameters).execute
    end

  end

end
