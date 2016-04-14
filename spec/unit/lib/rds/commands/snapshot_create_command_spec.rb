require 'aws_helpers/rds_commands/commands/snapshot_create_command'
require 'aws_helpers/rds_commands/requests/snapshot_create_request'

describe AwsHelpers::RDSCommands::Commands::SnapshotCreateCommand do
  let(:instance_id) { '123' }
  let(:image_id) { '321' }
  let(:instance) { Aws::RDS::Types::Snapshot.new(instance_id: instance_id) }
  let(:result) { Aws::RDS::Types::Reservation.new(instances: [instance]) }
  let(:rds_client) { instance_double(Aws::RDS::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_rds_client: rds_client) }
  let(:request) { AwsHelpers::RDSCommands::Requests::SnapshotCreateRequest.new }

  before do
    request.image_id = image_id
    @command = AwsHelpers::RDSCommands::Commands::SnapshotCreateCommand.new(config, request)
    allow(ec2_client)
      .to receive(:run_instances)
      .and_return(result)
  end

  it 'calls run_instances on the client with the correct parameters' do
    expect(ec2_client)
      .to receive(:run_instances)
      .with(image_id: image_id, min_count: 1, max_count: 1)
    @command.execute
  end

  it 'adds the instance_id to the request' do
    @command.execute
    expect(request.instance_id).to eq(instance_id)
  end
end
