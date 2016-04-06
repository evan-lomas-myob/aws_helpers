require 'aws-sdk-core'
require 'aws_helpers/utilities/polling'

module AwsHelpers
  module Actions
    module EC2
      class GetWindowsPassword
        include AwsHelpers::Utilities::Polling

        def initialize(config, instance_id, pem_path, options = {})
          @client = config.aws_ec2_client
          @instance_id = instance_id
          @pem_path = pem_path
          @stdout = options[:stdout] || $stdout
          @delay = options[:delay] || 10
          @max_attempts = options[:max_attempts] || 6
        end

        def password
          encrypted_password = ''
          poll(@delay, @max_attempts) do
            encrypted_password = @client.get_password_data(instance_id: @instance_id).password_data
            !encrypted_password.empty?
          end
          private_key = OpenSSL::PKey::RSA.new(File.read(@pem_path))
          decoded = Base64.decode64(encrypted_password)
          begin
            private_key.private_decrypt(decoded)
          rescue OpenSSL::PKey::RSAError => error
            s = 'Hint: Check you are using the correct pem.file vs aws-access-key-id combination'
            @stdout.puts s
            raise error
          end
        end
      end
    end
  end
end
