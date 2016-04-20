require 'aws_helpers/rds_commands/commands/get_latest_snapshot_id_command'
require 'aws_helpers/rds_commands/requests/get_latest_snapshot_id_request'

describe AwsHelpers::RDSCommands::Commands::GetLatestSnapshotIdCommand do
  let(:db_instance_id) { '123' }
  let(:snapshot_name) { 'Batman' }
  let(:db_snapshot_id) { '321' }
  let(:old_snapshot) { Aws::RDS::Types::DBSnapshot.new(db_snapshot_identifier: '99', snapshot_create_time: Time.now - 24) }
  let(:snapshot) { Aws::RDS::Types::DBSnapshot.new(db_snapshot_identifier: db_snapshot_id, snapshot_create_time: Time.now) }
  let(:result) { Aws::RDS::Types::DBSnapshotMessage.new(db_snapshots: [old_snapshot, snapshot]) }
  let(:rds_client) { instance_double(Aws::RDS::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_rds_client: rds_client) }
  let(:request) { AwsHelpers::RDSCommands::Requests::GetLatestSnapshotIdRequest.new }

  before do
    request.db_instance_id = db_instance_id
    request.snapshot_name = snapshot_name
    @command = AwsHelpers::RDSCommands::Commands::GetLatestSnapshotIdCommand.new(config, request)
    allow(rds_client)
      .to receive(:describe_db_snapshots)
      .and_return(result)
  end

  it 'calls create_db_snapshot on the client with the correct parameters' do
    expect(rds_client)
      .to receive(:describe_db_snapshots)
      .with(db_instance_identifier: db_instance_id)
    @command.execute
  end

  it 'adds the db_instance_id of the latest snapshot to the request' do
    @command.execute
    expect(request.snapshot_id).to eq(db_snapshot_id)
  end
end
