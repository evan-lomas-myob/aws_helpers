require 'aws_helpers/ec2'
require 'aws_helpers/actions/ec2/instances_find_by_tags'

include AwsHelpers
include AwsHelpers::Actions::EC2

describe InstancesFindByTags do

  let(:ec2_client) { instance_double(Aws::EC2::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: ec2_client) }
  let(:tags) { [{name: 'Name', value: 'value'}] }
  let(:instances) { [ instance_double(Aws::EC2::Types::Instance, instance_id: 'i-12345678') ] }
  let(:reservation) { [
      instance_double(Aws::EC2::Types::Reservation,
                      instances: instances)] }

  before(:each) do
    allow(ec2_client)
        .to receive(:describe_instances)
                .and_return(
                    instance_double(
                        Aws::EC2::Types::DescribeInstancesResult,
                        reservations: reservation
                    )
                )
  end

  it 'should call Aws::EC2::Client #describe_instances with correct parameters' do
    expect(ec2_client).to receive(:describe_instances).with(filters: [{name: 'tag:Name', values: ['value']}])
    InstancesFindByTags.new(config, tags).execute
  end

  it 'should return the instance ID matching the tag' do
    expect(InstancesFindByTags.new(config, tags).execute).to eql(instances[0])
  end


end
