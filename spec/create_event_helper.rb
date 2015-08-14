require 'time'
require 'aws-sdk-resources'
require 'rspec'

class CreateEventHelper

  include RSpec::Mocks::ExampleMethods

  def initialize(stack_name, timestamp = Time.parse('01-Jan-2015 00:00:00'), resource_status, resource_type)
    @stack_name = stack_name
    @timestamp = timestamp
    @resource_status = resource_status
    @resource_type = resource_type
    @logical_resource_id = 'ResourceID'
    @resource_status_reason = 'Success/failure message'
  end

  def execute
    instance_double(Aws::CloudFormation::Event,
                    stack_name: @stack_name,
                    timestamp: @timestamp,
                    resource_status: @resource_status,
                    resource_type: @resource_type,
                    logical_resource_id: @logical_resource_id,
                    resource_status_reason: @resource_status_reason)
  end

end