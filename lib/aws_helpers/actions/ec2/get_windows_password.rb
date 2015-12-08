require 'aws-sdk-core'

module AwsHelpers
  module Actions
    module EC2

      class GetWindowsPassword

        def initialize(config, instance_id, pem_path, stdout = $stdout)
          @config = config
          @instance_id = instance_id
          @pem_path = pem_path
          @stdout = stdout
        end

        def get_password
          client = @config ? @config.aws_ec2_client : Aws::EC2::Client.new()
          encrypted_password = client.get_password_data(instance_id: @instance_id).password_data
          puts "Encrypted Password: #{encrypted_password}"
          private_key = OpenSSL::PKey::RSA.new(File.read(@pem_path))
          puts "Private Key: \n#{private_key} from #{@pem_path}"
          decoded = Base64.decode64(encrypted_password)
          begin
            private_key.private_decrypt(decoded)
          rescue OpenSSL::PKey::RSAError => error
            @stdout.puts 'Hint: Check you are using the correct pem.file vs aws-access-key-id combination'
            raise error
          end

        end

      end

    end
  end
end