require 'aws_helpers/ec2'
require 'aws_helpers/actions/ec2/images_find_by_tags'

include AwsHelpers
include AwsHelpers::Actions::EC2

describe InstanceFindByTagValue do

  let(:ec2_client) { instance_double(Aws::EC2::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: ec2_client) }

  let(:instance_id) { 'i-12345678' }

  let(:filter_tag) { 'name-tag' }
  let(:tags) { [ values: filter_tag ] }

  let(:request_values) { [ filter_tag ] }

  let(:filters) { [ { name: 'tag-value', values: [ filter_tag ] } ] }
  let(:request) { { filters: filters } }

  let(:instances) { [ instance_double(Aws::EC2::Types::Instance, instance_id: instance_id) ] }
  let(:reservations) { [instance_double(Aws::EC2::Types::Reservation, instances: instances)] }
  let(:describe_instances_result) { instance_double(Aws::EC2::Types::DescribeInstancesResult, reservations: reservations) }

  it 'should find the images using a tags array as a filter' do
    allow(ec2_client).to receive(:describe_instances).with(request).and_return(describe_instances_result)
    expect(InstanceFindByTagValue.new(config, request_values).execute).to be(describe_instances_result)
  end

end
