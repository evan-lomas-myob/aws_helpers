module AwsHelpers
  module RDSCommands
    module Requests
      PollInstanceAvailableRequest = Struct.new(
          :std_out,
          :db_instance_identifier,
          :snapshot_name,
          :use_name,
          :instance_polling,
          :snapshot_polling) do
            def initialize(*args)
              super(*args)
              self.instance_polling = {
                max_attempts: 2,
                delay: 30
              }
            end
          end
    end
  end
end
