require 'aws_helpers/ec2_commands/commands/get_instance_id_by_tags_command'
require 'aws_helpers/ec2_commands/requests/get_instance_id_by_tags_request'

describe AwsHelpers::EC2Commands::Commands::GetInstanceIdByTagsCommand do
  let(:instance_name) { 'Gotham' }
  let(:instance_id) { '123' }
  let(:instance) { Aws::EC2::Types::Instance.new(instance_id: instance_id) }
  let(:reservation) { Aws::EC2::Types::Reservation.new(instances: [instance]) }
  let(:instances) { Aws::EC2::Types::DescribeInstancesResult.new(reservations: [reservation]) }
  let(:ec2_client) { instance_double(Aws::EC2::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: ec2_client) }
  let(:request) { AwsHelpers::EC2Commands::Requests::GetInstanceIdByTagsRequest.new }

  before do
    request.tags = { Name: 'Batman', Cities: %w(Melbourne, Gotham) }
    @command = AwsHelpers::EC2Commands::Commands::GetInstanceIdByTagsCommand.new(config, request)
    allow(ec2_client).to receive(:describe_instances)
      .with(filters: [{ name: 'tag:Name', values: ['Batman'] }, { name: 'tag:Cities', values: %w(Melbourne, Gotham) }])
      .and_return(instances)
  end

  it 'returns the instance id' do
    @command.execute
    expect(request.instance_id).to eq(instance_id)
  end
end
