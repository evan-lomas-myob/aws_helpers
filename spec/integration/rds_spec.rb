require 'aws-sdk-core'
require 'aws_helpers'

describe AwsHelpers::RDS do
  stack_name = 'rds-stack'
  db_instance_id = nil

  after(:all) do
    AwsHelpers::RDS.new.snapshots_delete(db_instance_id)
    delete_stack(stack_name)
  end

  before(:all) do
    db_instance_id = create_stack(stack_name, 'rds.template.json')
  end

  describe '#snapshot_create' do
    it 'should snapshot the database' do
      AwsHelpers::RDS.new.snapshot_create(db_instance_id)
    end
  end

  describe '#snapshot_delete' do
    it 'should delete all snapshots' do
      AwsHelpers::RDS.new.snapshot_create(db_instance_id)
      AwsHelpers::RDS.new.snapshots_delete(db_instance_id)
      snapshot_count = snapshot_count(db_instance_id)
      expect(snapshot_count).to eql(0)
    end
  end

  describe '#latest_snapshot' do
    it 'should get the latest snapshot identifier' do
      AwsHelpers::RDS.new.snapshot_create(db_instance_id)
      AwsHelpers::RDS.new.snapshot_create(db_instance_id)
      latest_snapshot_identifier = latest_snapshot_id(db_instance_id)
      expect(AwsHelpers::RDS.new.latest_snapshot(db_instance_id)).to eql(latest_snapshot_identifier)
    end
  end

  private

  def latest_snapshot_id(db_instance_identifier)
    describe_snapshots(db_instance_identifier).db_snapshots.sort_by(&:snapshot_create_time).last.db_snapshot_identifier
  end

  def snapshot_count(db_instance_identifier)
    describe_snapshots(db_instance_identifier).db_snapshots.size
  end

  def describe_snapshots(db_instance_identifier)
    Aws::RDS::Client.new.describe_db_snapshots(db_instance_identifier: db_instance_identifier, snapshot_type: 'manual')
  end

  def delete_stack(stack_name)
    client = Aws::CloudFormation::Client.new
    client.delete_stack(stack_name: stack_name)
    client.wait_until(:stack_delete_complete, stack_name: stack_name)
  end

  def create_stack(stack_name, fixture)
    client = Aws::CloudFormation::Client.new
    client.create_stack(
      stack_name: stack_name,
      template_body: IO.read(File.join(File.dirname(__FILE__), 'fixtures', fixture))
    )
    client.wait_until(:stack_create_complete, stack_name: stack_name)
    client.describe_stacks(stack_name: stack_name).stacks.first.outputs.find { |output| output.output_key == 'DBInstanceId' }.output_value
  end
end
