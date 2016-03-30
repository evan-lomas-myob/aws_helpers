require 'aws-sdk-core'
require 'aws_helpers/config'
require 'aws_helpers/actions/rds/poll_instance_available'

describe AwsHelpers::Actions::RDS::PollInstanceAvailable do
  let(:rds_client) { instance_double(Aws::RDS::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_rds_client: rds_client) }
  let(:stdout) { instance_double(IO) }
  let(:db_instance_identifier) { 'instance_id' }

  describe '#execute' do
    before(:each) do
      allow(stdout).to receive(:puts)
    end

    it 'should call Aws::RDS::Client #describe_db_instances with correct parameters' do
      allow_describe_db_instances(rds_client, db_instance_identifier, 'available')
      expect(rds_client).to receive(:describe_db_instances).with(db_instance_identifier: db_instance_identifier)
      poll_instance_available(config, db_instance_identifier, stdout: stdout, max_attempts: 1, delay: 0)
    end

    it 'should output to stdout with the instance status' do
      allow_describe_db_instances(rds_client, db_instance_identifier, 'available')
      expect(stdout).to receive(:puts).with("RDS Instance=#{db_instance_identifier}, Status=available")
      poll_instance_available(config, db_instance_identifier, stdout: stdout, max_attempts: 1, delay: 0)
    end

    it 'should poll until the snapshot status is available' do
      allow_describe_db_instances(rds_client, db_instance_identifier, 'creating', 'available')
      expect(rds_client).to receive(:describe_db_instances).with(db_instance_identifier: db_instance_identifier).exactly(2).times
      poll_instance_available(config, db_instance_identifier, stdout: stdout, max_attempts: 2, delay: 0)
    end

    it 'should raise a Aws::Waiters::Errors::TooManyAttemptsError if the snapshot is not available within the number of attempts' do
      allow_describe_db_instances(rds_client, db_instance_identifier, 'creating')
      expect do
        poll_instance_available(config, db_instance_identifier, stdout: stdout, max_attempts: 1, delay: 0)
      end.to raise_error(Aws::Waiters::Errors::TooManyAttemptsError)
    end
  end

  def poll_instance_available(config, db_instance_identifier, options)
    AwsHelpers::Actions::RDS::PollInstanceAvailable.new(config, db_instance_identifier, options).execute
  end

  def allow_describe_db_instances(rds_client, db_instance_identifier, *responses)
    allow(rds_client)
      .to receive(:describe_db_instances)
      .and_return(
        *responses.map { |response| create_response(db_instance_identifier, response) }
      )
  end

  def create_response(db_instance_identifier, status)
    Aws::RDS::Types::DBInstanceMessage.new(
      db_instances: [
        Aws::RDS::Types::DBInstance.new(
          db_instance_identifier: db_instance_identifier,
          db_instance_status: status
        )
      ]
    )
  end
end
