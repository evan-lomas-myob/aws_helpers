require 'aws-sdk-core'
require 'base64'
require 'openssl'

module AwsHelpers
  module EC2
    class Utils

      def initialize(ec2_client)
        @ec2_client = ec2_client
      end

      # Returns the encrypted Windows administrator password for a given instance.
      def get_windows_password(instance_id)
        data = @ec2_client.get_password_data({ instance_id: instance_id })
        encrypted_password = data.password_data
        encrypted_password
      end

      # Returns the plaintext Windows administrator password for a given instance.
      def get_decrypted_windows_password(instance_id, private_keyfile)
        encrypted_password = get_windows_password(instance_id)
        decrypt_windows_password(encrypted_password, private_keyfile)
      end

      private

      # Decrypts an encrypted password using a provided RSA
      # private key file (PEM-format).
      def decrypt_windows_password(encrypted_password, private_keyfile)
        encrypted_password_bytes = Base64.decode64(encrypted_password)
        private_keydata = File.open(private_keyfile, "r").read
        private_key = OpenSSL::PKey::RSA.new(private_keydata)
        private_key.private_decrypt(encrypted_password_bytes)
      end

    end
  end
end