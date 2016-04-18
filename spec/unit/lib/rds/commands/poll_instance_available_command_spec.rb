require 'aws_helpers/rds_commands/commands/poll_instance_available_command'
require 'aws_helpers/rds_commands/requests/poll_instance_available_request'

describe AwsHelpers::RDSCommands::Commands::PollInstanceAvailableCommand do
  let(:instance) { Aws::RDS::Types::DBInstance.new }
  let(:result) { Aws::RDS::Types::DBInstanceMessage.new(db_instances: [instance]) }
  let(:rds_client) { instance_double(Aws::RDS::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_rds_client: rds_client) }
  let(:request) { AwsHelpers::RDSCommands::Requests::PollInstanceAvailableRequest.new }

  before do
    request.instance_polling = { max_attempts: 2, delay: 0 }
    @command = AwsHelpers::RDSCommands::Commands::PollInstanceAvailableCommand.new(config, request)
    allow(rds_client)
      .to receive(:describe_db_instances)
      .and_return(result)
  end

  it 'polls' do
    instance.db_instance_status = 'available'
    expect(@command).to receive(:poll)
    @command.execute
  end

  it 'returns if the instance status is available' do
    instance.db_instance_status = 'available'
    expect { @command.execute }.not_to raise_error
  end

  it 'times out if the instance status is anything else' do
    instance.db_instance_status = 'failed'
    expect(rds_client).to receive(:describe_db_instances).twice
    expect { @command.execute }.to raise_error(Aws::Waiters::Errors::TooManyAttemptsError)
  end
end
