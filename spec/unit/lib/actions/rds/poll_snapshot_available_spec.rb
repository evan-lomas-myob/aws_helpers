require 'aws-sdk-core'
require 'aws_helpers/config'
require 'aws_helpers/actions/rds/poll_snapshot_available'

describe AwsHelpers::Actions::RDS::PollSnapshotAvailable do

  let(:rds_client) { instance_double(Aws::RDS::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_rds_client: rds_client) }
  let(:stdout) { instance_double(IO) }

  let(:snapshot_id) { 'snapshot_id' }

  describe '#execute' do

    before(:each){
      allow(stdout).to receive(:puts)
    }

    it 'should call Aws::RDS::Client #describe_db_snapshots with correct parameters' do
      allow(rds_client)
        .to receive(:describe_db_snapshots)
              .and_return(
                create_response(snapshot_id, 'available')
              )
      expect(rds_client).to receive(:describe_db_snapshots).with(db_snapshot_identifier: snapshot_id)
      poll_db_snapshot(config, snapshot_id, stdout: stdout, max_attempts: 1, delay: 0)
    end

    it 'should call stdout with the snapshot status and progress' do
      allow(rds_client)
        .to receive(:describe_db_snapshots)
              .and_return(
                create_response(snapshot_id, 'available', 100)
              )
      expect(stdout).to receive(:puts).with("RDS Snapshot #{snapshot_id} available, progress 100%")
      poll_db_snapshot(config, snapshot_id, stdout: stdout, max_attempts: 1, delay: 0)
    end


    it 'should poll until the snapshot status is available' do
      allow(rds_client)
        .to receive(:describe_db_snapshots)
              .and_return(
                create_response(snapshot_id, 'creating'),
                create_response(snapshot_id, 'available')
              )
      expect(rds_client).to receive(:describe_db_snapshots).with(db_snapshot_identifier: snapshot_id).exactly(2).times
      poll_db_snapshot(config, snapshot_id, stdout: stdout, max_attempts: 2, delay: 0)
    end

    it 'should raise a StandardError if the snapshot status is deleting' do
      allow(rds_client)
        .to receive(:describe_db_snapshots)
              .and_return(
                create_response(snapshot_id, 'deleting')
              )
      expect {
        poll_db_snapshot(config, snapshot_id, stdout: stdout, max_attempts: 1, delay: 0)
      }.to raise_error(StandardError, "RDS Failed to create snapshot #{snapshot_id}")
    end

    it 'should raise a Aws::Waiters::Errors::TooManyAttemptsError if the snapshot is not available within the number of attempts' do
      allow(rds_client)
        .to receive(:describe_db_snapshots)
              .and_return(
                create_response(snapshot_id, 'creating')
              )
      expect {
        poll_db_snapshot(config, snapshot_id, stdout: stdout, max_attempts: 1, delay: 0)
      }.to raise_error(Aws::Waiters::Errors::TooManyAttemptsError)
    end


  end

  def poll_db_snapshot(config, snapshot_id, options)
    AwsHelpers::Actions::RDS::PollSnapshotAvailable.new(config, snapshot_id, options).execute
  end

  def create_response(snapshot_id, response, percent_progress = nil)
    Aws::RDS::Types::DBSnapshotMessage.new(
      db_snapshots: [
        Aws::RDS::Types::DBSnapshot.new(
          db_snapshot_identifier: snapshot_id,
          status: response,
          percent_progress: percent_progress)
      ]
    )
  end

end