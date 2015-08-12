require 'aws-sdk-core'
require 'aws-sdk-resources'
require 'aws_helpers'

describe AwsHelpers::CloudFormation do

  stack_name = 'cloudformation-test-stack'

  before(:each) {
    create_stack(stack_name)
  }

  after(:each) {
    delete_stack(stack_name)
  }

  describe '#stack_exists?' do

    it 'should check if the stack exists once it is created' do
      expect(AwsHelpers::CloudFormation.new.stack_exists?(stack_name: stack_name)).to match(stack_name)
    end

  end

  private

  def delete_stack(stack_name)
    client = Aws::CloudFormation::Client.new
    client.delete_stack(stack_name: stack_name)
    client.wait_until(:stack_delete_complete, stack_name: stack_name)
  end

  def create_stack(stack_name)
    client = Aws::CloudFormation::Client.new
    client.create_stack(
        {
            stack_name: stack_name,
            template_body: IO.read(File.join(File.dirname(__FILE__), 'fixtures', 'auto_scaling.template.json')),
        }
    )
    responses = %w(CREATE_COMPLETE DELETE_COMPLETE ROLLBACK_COMPLETE UPDATE_COMPLETE UPDATE_ROLLBACK_COMPLETE ROLLBACK_FAILED UPDATE_ROLLBACK_FAILED DELETE_FAILED)
    stack_info = Aws::CloudFormation::Stack.new(stack_name, client: client)
    stack_info.wait_until(max_attempts: 30, delay: 5) { |stack_info|
      puts "Stack - #{stack_name} status #{stack_info.stack_status}"
      responses.include?(stack_info.stack_status)
    }
  end

end
