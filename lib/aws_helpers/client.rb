require_relative 'config'

module AwsHelpers
  class Client
    attr_reader :config

    def initialize(options)
      @config = AwsHelpers::Config.new(options)
    end

    # @yield [config] Yields to config if a block is passed
    def configure
      yield config if block_given?
    end
  end
end
