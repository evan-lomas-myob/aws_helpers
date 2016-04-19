module AwsHelpers
  module KMSCommands
    module Requests
      GetKeyArnRequest = Struct.new(
        :alias_name,
        :key_arn,
        :use_key_metadata_arn) do
          def initialize(*args)
            super(*args)
          end
        end
    end
  end
end
