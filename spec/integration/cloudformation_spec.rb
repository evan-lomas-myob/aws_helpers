require 'aws-sdk-core'
require 'aws-sdk-resources'
require 'aws_helpers'
require 'aws_helpers/actions/cloud_formation/stack_error_events'
require 'aws_helpers/actions/cloud_formation/stack_retrieve_events'
require 'aws_helpers/actions/cloud_formation/stack_initiation_event'
require 'aws_helpers/actions/cloud_formation/stack_completion_event'
require 'aws_helpers/actions/cloud_formation/stack_events_filter_failed'
require 'aws_helpers/actions/cloud_formation/stack_events_filter_post_initiation'

describe AwsHelpers::CloudFormation do

  config = AwsHelpers::Config.new({})
  stack_name = 'cloudformation-test-stack'

  before(:each) {
    create_stack(stack_name, config)
    stack_events(stack_name, config)
  }

  after(:each) {
    delete_stack(stack_name, config)
  }

  describe '#stack_exists?' do

    it 'should check if the stack exists once it is created' do
      expect(AwsHelpers::CloudFormation.new.stack_exists?(stack_name: stack_name)).to match(stack_name)
    end

  end

  private

  def delete_stack(stack_name, config)
    AwsHelpers::Actions::CloudFormation::StackDelete.new($stdout, config, stack_name).execute
  end

  def create_stack(stack_name, config)
    client = config.aws_cloud_formation_client
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
    stack_events(stack_name, config)
  end

  def stack_events(stack_name, config)
    AwsHelpers::Actions::CloudFormation::StackErrorEvents.new($stdout,config, stack_name).execute
  end

end
