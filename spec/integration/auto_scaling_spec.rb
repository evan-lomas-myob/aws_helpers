require 'aws-sdk-core'
require 'aws_helpers'

describe AwsHelpers::AutoScaling do

  client = Aws::CloudFormation::Client.new
  stack_name = 'test-stack'
  auto_scaling_group_name = nil

  before(:all) {
    client.create_stack(
      {
        stack_name: stack_name,
        template_body: IO.read(File.join(File.dirname(__FILE__), 'fixtures', 'auto_scaling.template')),
      }
    )
    client.wait_until(:stack_create_complete, stack_name: stack_name)
    auto_scaling_group_name = client.describe_stacks(stack_name: stack_name).stacks.first.outputs.find { |output| output.output_key == 'AutoScalingGroupName' }.output_value
  }

  after(:all) {
    client.delete_stack(stack_name: stack_name)
    client.wait_until(:stack_delete_complete, stack_name: stack_name)
  }

  describe 'update_desired_capacity' do

    it 'update the auto scaling groups capacity to 1' do
      AwsHelpers::AutoScaling.new.update_desired_capacity(
        auto_scaling_group_name: auto_scaling_group_name,
        desired_capacity: 1)
    end

  end


end
