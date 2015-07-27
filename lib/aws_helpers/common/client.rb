module AwsHelpers

  module Common

    class Client
      # @param [Hash] options Constructs an API client.
      # @option options [required, Credentials] :credentials Your
      #   AWS credentials.  The following locations will be searched in order
      #   for credentials:
      #
      #   * `:access_key_id`, `:secret_access_key`, and `:session_token` options
      #   * ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY']
      #   * `HOME/.aws/credentials` shared credentials file
      #   * EC2 instance profile credentials
      #
      # @option options [String] :profile Used when loading credentials
      #   from the shared credentials file at HOME/.aws/credentials.  When not
      #   specified, 'default' is used.
      #
      # @option options [String] :access_key_id Used to set credentials
      #   statically.
      #
      # @option options [String] :secret_access_key Used to set
      #   credentials statically.
      #
      # @option options [String] :session_token Used to set credentials
      #   statically.
      #
      def initialize(options)
        @options = { retry_limit: 5 }.merge(options)
        #Add logger here
      end

    end

  end

end
