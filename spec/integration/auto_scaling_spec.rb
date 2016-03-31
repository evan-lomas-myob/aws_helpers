require 'aws-sdk-core'
require 'aws_helpers'

describe AwsHelpers::AutoScaling do
  stack_name = 'test-stack'
  auto_scaling_group_name = nil

  after(:each) do
    delete_stack(stack_name)
  end

  context 'without a load balancer' do
    before(:each) do
      auto_scaling_group_name = create_stack(stack_name, 'auto_scaling.template.json')
    end

    describe '#retrieve_desired_capacity' do
      it 'should return the desired capacity' do
        expect(AwsHelpers::AutoScaling.new.retrieve_desired_capacity(auto_scaling_group_name)).to be(0)
      end
    end

    describe '#update_desired_capacity' do
      it 'should update the auto scaling groups desired capacity' do
        AwsHelpers::AutoScaling.new.update_desired_capacity(auto_scaling_group_name, 1)
        expect(AwsHelpers::AutoScaling.new.retrieve_desired_capacity(auto_scaling_group_name)).to be(1)
      end
    end
  end

  context 'with a load balancer' do
    before(:each) do
      auto_scaling_group_name = create_stack(stack_name, 'auto_scaling_load_balancer.template.json')
    end

    describe '#update_desired_capacity' do
      it 'should update the auto scaling groups desired capacity' do
        AwsHelpers::AutoScaling.new.update_desired_capacity(auto_scaling_group_name, 1)
        expect(AwsHelpers::AutoScaling.new.retrieve_desired_capacity(auto_scaling_group_name)).to be(1)
      end
    end
  end

  private

  def delete_stack(stack_name)
    client = Aws::CloudFormation::Client.new
    client.delete_stack(stack_name: stack_name)
    client.wait_until(:stack_delete_complete, stack_name: stack_name)
  end

  def create_stack(stack_name, fixture)
    client = Aws::CloudFormation::Client.new
    client.create_stack(
      stack_name: stack_name,
      template_body: IO.read(File.join(File.dirname(__FILE__), 'fixtures', fixture))
    )
    client.wait_until(:stack_create_complete, stack_name: stack_name)
    client.describe_stacks(stack_name: stack_name).stacks.first.outputs.find { |output| output.output_key == 'AutoScalingGroupName' }.output_value
  end
end
