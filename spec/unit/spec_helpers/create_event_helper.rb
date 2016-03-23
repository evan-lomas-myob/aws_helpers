require 'time'
require 'aws-sdk-core'

class CreateEventHelper

  def initialize(stack_name, timestamp = Time.parse('01-Jan-2015 00:00:00'), resource_status, resource_type)
    @stack_name = stack_name
    @timestamp = timestamp
    @resource_status = resource_status
    @resource_type = resource_type
  end

  def execute
    Aws::CloudFormation::Types::StackEvent.new(
      stack_name: @stack_name,
      timestamp: @timestamp,
      resource_status: @resource_status,
      resource_type: @resource_type,
      logical_resource_id: 'ResourceID',
      resource_status_reason: 'Success/failure message')
  end

end