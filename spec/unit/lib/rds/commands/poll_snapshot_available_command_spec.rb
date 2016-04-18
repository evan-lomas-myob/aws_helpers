require 'aws_helpers/rds_commands/commands/poll_snapshot_available_command'
require 'aws_helpers/rds_commands/requests/poll_snapshot_available_request'

describe AwsHelpers::RDSCommands::Commands::PollSnapshotAvailableCommand do
  let(:snapshot) { Aws::RDS::Types::DBSnapshot.new }
  let(:result) { Aws::RDS::Types::DBSnapshotMessage.new(db_snapshots: [snapshot]) }
  let(:rds_client) { instance_double(Aws::RDS::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_rds_client: rds_client) }
  let(:request) { AwsHelpers::RDSCommands::Requests::PollSnapshotAvailableRequest.new }

  before do
    request.snapshot_polling = { max_attempts: 2, delay: 0 }
    @command = AwsHelpers::RDSCommands::Commands::PollSnapshotAvailableCommand.new(config, request)
    allow(rds_client)
      .to receive(:describe_db_snapshots)
      .and_return(result)
  end

  it 'polls' do
    snapshot.status = 'available'
    expect(@command).to receive(:poll)
    @command.execute
  end

  it 'returns if the snapshot status is available' do
    snapshot.status = 'available'
    expect { @command.execute }.not_to raise_error
  end

  it 'raises an exception if the snapshot status is deleting' do
    snapshot.status = 'deleting'
    request.snapshot_name = 'Batman'
    expect { @command.execute }.to raise_error(RuntimeError)
  end

  it 'times out if the snapshot status is anything else' do
    snapshot.status = 'partying'
    expect(rds_client).to receive(:describe_db_snapshots).twice
    expect { @command.execute }.to raise_error(Aws::Waiters::Errors::TooManyAttemptsError)
  end
end
