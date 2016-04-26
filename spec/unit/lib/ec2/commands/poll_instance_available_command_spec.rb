require 'aws_helpers/ec2_commands/commands/poll_instance_available_command'
require 'aws_helpers/ec2_commands/requests/instance_create_request'

describe AwsHelpers::EC2Commands::Commands::PollInstanceAvailableCommand do
  let(:instance) { Aws::EC2::Types::Instance.new }
  let(:reservation) { Aws::EC2::Types::Reservation.new(instances: [instance]) }
  let(:result) { Aws::EC2::Types::DescribeInstancesResult.new(reservations: [reservation]) }
  let(:ec2_client) { instance_double(Aws::EC2::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: ec2_client) }
  let(:request) { AwsHelpers::EC2Commands::Requests::InstanceCreateRequest.new }

  before do
    request.instance_polling = { delay: 0, max_attempts: 5 }
    @command = AwsHelpers::EC2Commands::Commands::PollInstanceAvailableCommand.new(config, request)
    allow(ec2_client)
      .to receive(:describe_instances)
      .and_return(result)
  end

  it 'polls' do
    instance.state = 'available'
    expect(@command).to receive(:poll)
    @command.execute
  end

  it 'returns if the instance status is available' do
    instance.state = 'available'
    expect { @command.execute }.not_to raise_error
  end

  it 'time out if the instance is not available' do
    instance.state = 'failed'
    expect { @command.execute }.to raise_error(Aws::Waiters::Errors::TooManyAttemptsError)
  end
end
