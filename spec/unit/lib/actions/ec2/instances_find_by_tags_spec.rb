require 'aws_helpers/ec2'
require 'aws_helpers/actions/ec2/instances_find_by_tags'

include AwsHelpers
include AwsHelpers::Actions::EC2

describe InstancesFindByTags do
  let(:ec2_client) { instance_double(Aws::EC2::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: ec2_client) }
  let(:tags_string) { 'name: value' }
  let(:tags_array) { [{ name: 'Name', value: 'value' }] }
  let(:tags_hash) { { 'Name' => 'value', 'Multi' => %w(a b) } }
  let(:state) { instance_double(Aws::EC2::Types::InstanceState, name: 'running') }
  let(:instances) { [instance_double(Aws::EC2::Types::Instance, instance_id: 'i-12345678', state: state)] }
  let(:reservation) { [instance_double(Aws::EC2::Types::Reservation, instances: instances)] }

  before(:each) do
    allow(ec2_client).to receive(:describe_instances).with(anything).and_return(instance_double(Aws::EC2::Types::DescribeInstancesResult, reservations:reservation))
  end

  it 'should display a deprecation warning when called with an array' do
    expect { InstancesFindByTags.new(config, tags_array).execute }.to output("Deprecation warning: AWS::EC2#instances_find_by_tags now accepts a hash instead of an array\n").to_stderr
  end

  it 'should call Aws::EC2::Client #describe_instances with correct parameters when called with a hash' do
    expected_filters = [{ name: 'tag:Name', values: ['value'] }, { name: 'tag:Multi', values: %w(a b) }]
    expect(ec2_client).to receive(:describe_instances).with(filters: expected_filters)
    InstancesFindByTags.new(config, tags_hash).execute
  end

  it 'should return the instance ID matching the tag' do
    expect(InstancesFindByTags.new(config, tags_hash).execute).to eql(instances)
  end

  it 'should raise an error when the wrong tag type' do
    expect { InstancesFindByTags.new(config, tags_string).execute }.to raise_error(ArgumentError)
  end
end
