module AwsHelpers
  module EC2Commands
    module Requests
      ImageAddUserRequest = Struct.new(
        :stdout,
        :image_id,
        :user_id)
    end
  end
end
