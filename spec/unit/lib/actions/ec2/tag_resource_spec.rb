require 'aws-sdk-core'
require 'aws_helpers/config'
require 'aws_helpers/actions/ec2/tag_resource'

describe AwsHelpers::Actions::EC2::TagResource do
  describe '#execute' do
    let(:aws_ec2_client) { instance_double(Aws::EC2::Client) }
    let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: aws_ec2_client) }
    let(:resource_id) { 'resource_id' }
    let(:tags) { [{ key: 'key', value: 'value' }] }

    it 'should call Aws::EC2::Client #create_tags with the correct parameters' do
      expect(aws_ec2_client).to receive(:create_tags).with(resources: [resource_id], tags: tags)
      AwsHelpers::Actions::EC2::TagResource.new(config, resource_id, tags).execute
    end
  end
end
