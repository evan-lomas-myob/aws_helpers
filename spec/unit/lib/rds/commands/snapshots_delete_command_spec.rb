require 'aws_helpers/rds_commands/commands/snapshots_delete_command'
require 'aws_helpers/rds_commands/requests/snapshots_delete_request'

describe AwsHelpers::RDSCommands::Commands::SnapshotsDeleteCommand do
  let(:db_instance_id) { '123' }
  let(:snapshot_name) { 'Batman' }
  let(:old_db_snapshot_id) { '654' }
  let(:db_snapshot_id) { '321' }
  let(:old_snapshot) { Aws::RDS::Types::DBSnapshot.new(db_snapshot_identifier: old_db_snapshot_id, snapshot_create_time: (Date.today - 3).to_time) }
  let(:snapshot) { Aws::RDS::Types::DBSnapshot.new(db_snapshot_identifier: db_snapshot_id, snapshot_create_time: (Date.today).to_time) }
  let(:result) { Aws::RDS::Types::DBSnapshotMessage.new(db_snapshots: [snapshot, old_snapshot]) }
  let(:rds_client) { instance_double(Aws::RDS::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_rds_client: rds_client) }
  let(:request) { AwsHelpers::RDSCommands::Requests::SnapshotsDeleteRequest.new }

  before do
    allow(AwsHelpers::Config).to receive(:new).and_return(config)
    request.db_instance_id = db_instance_id
    @command = AwsHelpers::RDSCommands::Commands::SnapshotsDeleteCommand.new(config, request)
    allow(rds_client).to receive(:describe_db_snapshots).and_return(result)
    allow(rds_client).to receive(:delete_db_snapshot)
  end

  it 'calls describe_db_snapshots on the client with the correct parameters' do
    expect(rds_client)
      .to receive(:describe_db_snapshots)
      .with(db_instance_identifier: db_instance_id, snapshot_type: 'manual')
    @command.execute
  end
  context 'when no time options are provided' do
    let(:command) { AwsHelpers::RDSCommands::Commands::SnapshotsDeleteCommand.new(config, request) }
    it 'calls delete on all snapshots' do
      expect(rds_client)
        .to receive(:delete_db_snapshot)
        .with(db_snapshot_identifier: old_db_snapshot_id)
      expect(rds_client)
        .to receive(:delete_db_snapshot)
        .with(db_snapshot_identifier: db_snapshot_id)
      command.execute
    end
  end

  context 'when a :time option is provided' do
    let(:command) { AwsHelpers::RDSCommands::Commands::SnapshotsDeleteCommand.new(config, request) }
    it 'calls delete on older snapshots' do
      request.older_than = (Date.today - 2).to_time
      expect(rds_client)
        .to receive(:delete_db_snapshot)
        .with(db_snapshot_identifier: old_db_snapshot_id)
      expect(rds_client)
        .not_to receive(:delete_db_snapshot)
        .with(db_snapshot_identifier: db_snapshot_id)
      command.execute
    end
  end

  context 'when a :days option is provided' do
    let(:command) { AwsHelpers::RDSCommands::Commands::SnapshotsDeleteCommand.new(config, request) }
    it 'calls delete on older snapshots' do
      request.older_than = (Date.today - 24).to_time
      expect(rds_client)
        .not_to receive(:delete_db_snapshot)
        .with(db_snapshot_identifier: old_db_snapshot_id)
      expect(rds_client)
        .not_to receive(:delete_db_snapshot)
        .with(db_snapshot_identifier: db_snapshot_id)
      command.execute
    end
  end
end
