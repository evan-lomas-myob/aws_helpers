require 'aws-sdk-core'

module AwsHelpers
  module Actions
    module CloudFormation


      class GetWindowsPassword

        def initialize(instance_id, pem_path)
          @instance_id = instance_id
          @pem_path = pem_path
        end

        def get_password
          client = Aws::EC2::Client.new()
          encrypted_password = client.get_password_data(instance_id: @instance_id).password_data
          private_key = OpenSSL::PKey::RSA.new(File.read(@pem_path))
          decoded = Base64.decode64(encrypted_password)
          begin
            private_key.private_decrypt(decoded)
          rescue OpenSSL::PKey::RSAError => error
            puts 'Hint: Check you are using the correct pem file'
            raise error
          end

        end

      end

    end
  end
end