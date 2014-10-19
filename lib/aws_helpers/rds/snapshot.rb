require_relative 'instance'

module AwsHelpers
  module RDS

    module SnapShotStatus
      CREATING='creating'
      AVAILABLE='available'
      DELETING = 'deleting'
    end

    class Snapshot

      def initialize(db_instance_id)
        @rds_client = Aws::RDS::Client.new
        @db_instance_id = db_instance_id
        @snapshot_id = nil
      end

      def create
        Instance.new(@db_instance_id).poll_available

        now = DateTime.now.strftime('%Y-%m-%d-%H-%M')
        name = tag_name
        snapshot_name = "#{name ? name : @db_instance_id}-#{now}"
        snapshot = @rds_client.create_db_snapshot(
          db_instance_identifier: @db_instance_id,
          db_snapshot_identifier: snapshot_name
        )
        @snapshot_id = snapshot[:db_snapshot][:db_snapshot_identifier]
        SnapshotProgress.report(self)
      end

      def delete(options = nil)
        delete_time = calculate_delete_time(options)

        response = @rds_client.describe_db_snapshots(db_instance_identifier: @db_instance_id, snapshot_type:'manual')
        response[:db_snapshots].each { |snapshot|
          create_time = snapshot[:snapshot_create_time]
          if create_time < delete_time
            db_snapshot_identifier = snapshot[:db_snapshot_identifier]
            puts "Deleting #{db_snapshot_identifier}"
            @rds_client.delete_db_snapshot(db_snapshot_identifier: db_snapshot_identifier)
          end
        }
      end

      def describe
        @rds_client.describe_db_snapshots(db_snapshot_identifier: @snapshot_id)[:db_snapshots].first if @snapshot_id
      end

      private

      def calculate_delete_time(options)
        delete_time = Time.now
        return delete_time unless options

        hours = options[:hours]
        days = options[:days]
        months = options[:months]

        delete_time = delete_time - hours_to_seconds(hours) if hours
        delete_time = delete_time - days_to_seconds(days) if days
        delete_time = (delete_time.to_datetime << months).to_time if months
        delete_time
      end

      def days_to_seconds(days)
        hours_to_seconds(24) * days
      end

      def hours_to_seconds(hours)
        60 * 60 * hours
      end

      def tag_name
        iam = Aws::IAM::Client.new
        region = iam.config.region
        account = iam.list_users[:users].first[:arn][/::(.*):/, 1]
        tags = @rds_client.list_tags_for_resource(resource_name: "arn:aws:rds:#{region}:#{account}:db:#{@db_instance_id}")
        name_tag = tags[:tag_list].detect { |tag| tag[:key] == 'Name' }
        name_tag[:value] if name_tag
      end

    end
  end
end
