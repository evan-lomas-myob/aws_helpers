require 'aws_helpers/ec2'
require 'aws_helpers/actions/ec2/instances_find_by_ids'

include AwsHelpers
include AwsHelpers::Actions::EC2

describe InstancesFindByIds do

  let(:ec2_client) { instance_double(Aws::EC2::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: ec2_client) }
  let(:ids) { %w(id1 id2) }
  let(:state) { instance_double(Aws::EC2::Types::InstanceState, name: 'running') }
  let(:instances) { [instance_double(Aws::EC2::Types::Instance, state: state)] }
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
    expect(ec2_client).to receive(:describe_instances).with(instance_ids: ids)
    InstancesFindByIds.new(config, ids).execute
  end

  it 'should return the instance ID matching the tag' do
    expect(InstancesFindByIds.new(config, ids).execute).to eql(instances)
  end


end
