require 'aws_helpers/ec2_commands/commands/poll_instance_healthy_command'
require 'aws_helpers/ec2_commands/requests/poll_instance_healthy_request'

describe AwsHelpers::EC2Commands::Commands::PollInstanceHealthyCommand do
  let(:instance_id) { '123' }
  let(:instance) { Aws::EC2::Types::Instance.new(instance_id: instance_id)}
  let(:reservation) { Aws::EC2::Types::Reservation.new(instances: [instance]) }
  let(:instances) { Aws::EC2::Types::DescribeInstancesResult.new(reservations: [reservation]) }
  let(:status_summary) { Aws::EC2::Types::InstanceStatusSummary.new }
  let(:instance_status) { Aws::EC2::Types::InstanceStatus.new(instance_status: status_summary) }
  let(:result) { Aws::EC2::Types::DescribeInstanceStatusResult.new(instance_statuses: [instance_status]) }
  let(:ec2_client) { instance_double(Aws::EC2::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_ec2_client: ec2_client) }
  let(:request) { AwsHelpers::EC2Commands::Requests::PollInstanceHealthyRequest.new }

  before do
    request.instance_polling = { delay: 0, max_attempts: 5 }
    request.instance_id = instance_id
    @command = AwsHelpers::EC2Commands::Commands::PollInstanceHealthyCommand.new(config, request)
    allow(ec2_client)
      .to receive(:describe_instances)
      .with(instance_ids: [instance_id])
      .and_return(instances)
    allow(ec2_client)
      .to receive(:describe_instance_status)
      .and_return(result)
  end

  it 'polls' do
    status_summary.status = 'ok'
    expect(@command).to receive(:poll)
    @command.execute
  end

  context 'when the instance is running windows' do
    before do
      instance.platform = 'windows'
    end

    it 'returns if the instance status is ok' do
      status_summary.status = 'ok'
      instance.state = 'running'
      expect { @command.execute }.not_to raise_error
    end

    it 'times out and raises an exception if the instance state is not running' do
      status_summary.status = 'ok'
      instance.state = 'stopped'
      expect(ec2_client).to receive(:describe_instances).exactly(5).times
      expect { @command.execute }.to raise_error(Aws::Waiters::Errors::TooManyAttemptsError)
    end

    it 'times out and raises an exception if the instance status is anything else' do
      status_summary.status = 'impaired'
      instance.state = 'running'
      expect(ec2_client).to receive(:describe_instance_status).exactly(5).times
      expect { @command.execute }.to raise_error(Aws::Waiters::Errors::TooManyAttemptsError)
    end
  end

  context 'when the instance is NOT running windows' do
    before do
      instance.platform = 'linux'
    end

    it 'returns if the instance state is running' do
      instance.state = 'running'
      expect { @command.execute }.not_to raise_error
    end

    it 'times out and raises an exception if the instance state is anything else' do
      instance.state = 'stopped'
      expect(ec2_client).to receive(:describe_instances).exactly(5).times
      expect { @command.execute }.to raise_error(Aws::Waiters::Errors::TooManyAttemptsError)
    end
  end
end
