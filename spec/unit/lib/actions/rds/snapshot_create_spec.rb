require 'aws_helpers/rds'
require 'aws_helpers/actions/rds/snapshot_create'
require 'aws_helpers/actions/rds/snapshot_construct_name'
require 'aws_helpers/actions/rds/poll_snapshot_available'

include AwsHelpers
include AwsHelpers::Actions::RDS

describe SnapshotCreate do

  let(:rds_client) { instance_double(Aws::RDS::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_rds_client: rds_client) }
  let(:snapshot_construct_name) { instance_double(SnapshotConstructName) }
  let(:poll_db_snapshots) { instance_double(PollSnapshotAvailable) }



end