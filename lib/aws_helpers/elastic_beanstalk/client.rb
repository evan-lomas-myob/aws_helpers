require 'aws-sdk-core'
require_relative '../common/client'
require_relative 'config'
require_relative 'version_deploy'
require_relative 'version_upload'

module AwsHelpers

  module ElasticBeanstalk

    class Client < AwsHelpers::Common::Client

      def initialize(options = {})
        super(AwsHelpers::ElasticBeanstalk::Config.new(options))
      end

      def deploy(application, environment, version)
      # def deploy(application:, environment:, version:)
      #   AwsHelpers::ElasticBeanstalk::VersionDeploy.new(config, application: application, environment: environment, version: version).execute
        AwsHelpers::ElasticBeanstalk::VersionDeploy.new(config, application, environment, version).execute
      end

      def upload(upload_parameters)
        AwsHelpers::ElasticBeanstalk::VersionUpload.new(config, upload_parameters).execute
      end

    end

    #
    # c = Client.new
    # c.deploy application: 'app', environment: 'env', version: 'v'
    #
    #
    # application = 'app'
    #
    # c.deploy application: application, environment: 'dev'
    #

    # class DeployParameters
    #
    #   def initialize(application, environment, version)
    #     @application = application
    #     @environment = environment
    #     @version =version
    #   end
    #
    #   attr_reader :application, :environment, :version
    #
    # end

    # class UploadParameters
    #
    #   def initialize(application, version, version_contents, zip_folder)
    #     @application = application
    #     @version = version
    #     @version_contents = version_contents
    #     @zip_folder = zip_folder
    #   end
    #
    #   attr_reader :application, :version, :version_contents, :zip_folder
    #
    # end


  end

end

