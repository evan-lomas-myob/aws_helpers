require 'aws-sdk-core'
require 'aws_helpers'

describe AwsHelpers::AutoScaling do

  # stack_name = 'test-stack'
  # auto_scaling_group_name = nil
  #
  # before(:each) {
  #   auto_scaling_group_name = create_stack(stack_name)
  # }
  #
  # after(:each) {
  #   delete_stack(stack_name)
  # }
  #
  # describe '#retrieve_desired_capacity' do
  #
  #   it 'should return the desired capacity' do
  #     expect(AwsHelpers::AutoScaling.new.retrieve_desired_capacity(
  #         auto_scaling_group_name: auto_scaling_group_name)).to be(0)
  #   end
  #
  # end
  #
  # describe '#update_desired_capacity' do
  #
  #   it 'should update the auto scaling groups desired capacity' do
  #     AwsHelpers::AutoScaling.new.update_desired_capacity(
  #         auto_scaling_group_name: auto_scaling_group_name,
  #         desired_capacity: 1)
  #     expect(desired_capacity(auto_scaling_group_name)).to be(1)
  #
  #   end
  #
  # end
  #
  # private
  #
  # def desired_capacity(auto_scaling_group_name)
  #   client = Aws::AutoScaling::Client.new
  #   response = client.describe_auto_scaling_groups(auto_scaling_group_names: [auto_scaling_group_name])
  #   response.find { |auto_scaling_group|
  #     auto_scaling_group.auto_scaling_group_name == auto_scaling_group_name
  #   }.desired_capacity
  # end
  #
  # def delete_stack(stack_name)
  #   client = Aws::CloudFormation::Client.new
  #   client.delete_stack(stack_name: stack_name)
  #   client.wait_until(:stack_delete_complete, stack_name: stack_name)
  # end
  #
  # def create_stack(stack_name)
  #   client = Aws::CloudFormation::Client.new
  #   client.create_stack(
  #       {
  #           stack_name: stack_name,
  #           template_body: IO.read(File.join(File.dirname(__FILE__), 'fixtures', 'auto_scaling.template')),
  #       }
  #   )
  #   client.wait_until(:stack_create_complete, stack_name: stack_name)
  #   client.describe_stacks(stack_name: stack_name).stacks.first.outputs.find { |output| output.output_key == 'AutoScalingGroupName' }.output_value
  #
  # end


end
