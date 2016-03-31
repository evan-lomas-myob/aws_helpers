require 'aws_helpers/nat'
require 'aws_helpers/cloud_formation'

describe AwsHelpers::NAT do
  before(:all) do
    template_json = IO.read(File.join(File.dirname(__FILE__), 'fixtures', 'nat.template.json'))
    AwsHelpers::CloudFormation.new.stack_provision('test-stack', template_json)
    outputs = AwsHelpers::CloudFormation.new.stack_outputs('test-stack')
    @allocation_id = outputs.find { |output| output.output_key == 'AllocationId' }.output_value
    @subnet_id = outputs.find { |output| output.output_key == 'SubnetId' }.output_value
  end

  after(:all) do
    AwsHelpers::CloudFormation.new.stack_delete('test-stack')
  end

  describe '#gateway_create' do
    after(:each) do
      AwsHelpers::NAT.new.gateway_delete(@gateway_id) if @gateway_id
    end

    it 'should create an gateway based on the instance' do
      @gateway_id = AwsHelpers::NAT.new.gateway_create(@subnet_id, @allocation_id)
    end
  end

  describe '#gateway_delete' do
    before(:each) do
      @gateway_id = AwsHelpers::NAT.new.gateway_create(@subnet_id, @allocation_id)
    end

    it 'should delete an gateway based on an gateway_id' do
      AwsHelpers::NAT.new.gateway_delete(@gateway_id)
    end
  end
end
