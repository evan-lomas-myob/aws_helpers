require 'aws_helpers/ec2_commands/commands/command'

module AwsHelpers
  module EC2Commands
    module Commands
      class GetWindowsPasswordCommand < AwsHelpers::EC2Commands::Commands::Command
        def initialize(config, request)
          @client = config.aws_ec2_client
          @request = request
        end

        def execute
          encrypted_password = ''
          poll(@delay, @max_attempts) do
            encrypted_password = @client.get_password_data(instance_id: @request.instance_id).password_data
            !encrypted_password.empty?
          end
          private_key = OpenSSL::PKey::RSA.new(File.read(@request.pem_path))
          decoded = Base64.decode64(encrypted_password)
          begin
            @request.windows_password = private_key.private_decrypt(decoded)
          rescue OpenSSL::PKey::RSAError => error
            hint = 'Hint: Check you are using the correct pem.file vs aws-access-key-id combination'
            @request.stdout.puts hint
            raise error
          end
        end
      end
    end
  end
end
