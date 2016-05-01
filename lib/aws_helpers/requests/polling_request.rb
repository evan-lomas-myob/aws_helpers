require 'aws_helpers/requests/request'

module AwsHelpers
  module Requests
    PollingRequest = AwsHelpers::Requests::Request.new(:delay, :max_attempts)
  end
end