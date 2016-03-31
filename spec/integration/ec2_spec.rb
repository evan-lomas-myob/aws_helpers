require 'aws_helpers/ec2'
require 'aws_helpers/cloud_formation'

describe AwsHelpers::EC2 do
  before(:all) do
    template_json = IO.read(File.join(File.dirname(__FILE__), 'fixtures', 'ec2.template.json'))
    AwsHelpers::CloudFormation.new.stack_provision('test-stack', template_json)
    outputs = AwsHelpers::CloudFormation.new.stack_outputs('test-stack')
    @instance_id_one = outputs.find { |output| output.output_key == 'InstanceIdOne' }.output_value
    @instance_id_two = outputs.find { |output| output.output_key == 'InstanceIdTwo' }.output_value
  end

  after(:all) do
    AwsHelpers::CloudFormation.new.stack_delete('test-stack')
  end

  describe '#image_create' do
    after(:each) do
      AwsHelpers::EC2.new.image_delete(@image_id) if @image_id
    end

    it 'should create an image based on the instance' do
      @image_id = AwsHelpers::EC2.new.image_create(@instance_id_one, 'test-image')
    end
  end

  describe '#image_delete' do
    before(:each) do
      @image_id = AwsHelpers::EC2.new.image_create(@instance_id_two, 'test-image')
    end

    it 'should delete an image based on an image_id' do
      AwsHelpers::EC2.new.image_delete(@image_id)
    end
  end
end
