require_relative 'config'

module AwsHelpers
  # Base class for all AWS clients.
  class Client
    attr_reader :config

    def initialize(options)
      @config = AwsHelpers::Config.new(options)
    end

    # Sets global options which are used by all implementing subclasses. This can be used to specify custom
    #  internal clients for particular resources.
    # @yield [config] Yields to a {Config} if a block is passed
    # @example Override the AWS EC2 and S3 clients with our own implementations
    #   client = AWSHelpers::EC2.new
    #   client.configure do |config|
    #     config.aws_ec2_client = MyClient::EC2.new
    #     config.aws_s3_client = MyClient::S3.new
    #   end
    def configure
      yield config if block_given?
    end
  end
end
