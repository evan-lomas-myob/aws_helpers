require 'aws_helpers/utilities/delete_time_builder'
require 'aws_helpers/utilities/time'

describe AwsHelpers::Utilities::DeleteTimeBuilder do

  let(:now) { Time.parse('31-Dec-2015 00:00:00') }

  describe '#build' do

    it 'should default to now' do
      delete_time = AwsHelpers::Utilities::DeleteTimeBuilder.new.build(time: now)
      expect(delete_time).to eql(now)
    end

    it 'should subtract years when set' do
      delete_time = AwsHelpers::Utilities::DeleteTimeBuilder.new.build(time: now, years: 1)
      expect(delete_time).to eql(now.prev_year(1))
    end

    it 'should subtract months when set' do
      delete_time = AwsHelpers::Utilities::DeleteTimeBuilder.new.build(time: now, months: 2)
      expect(delete_time).to eql(now.prev_month(2))
    end

    it 'should subtract days when set' do
      delete_time = AwsHelpers::Utilities::DeleteTimeBuilder.new.build(time: now, days: 3)
      expect(delete_time).to eql(now.prev_day(3))
    end

    it 'should subtract hours when set' do
      delete_time = AwsHelpers::Utilities::DeleteTimeBuilder.new.build(time: now, hours: 4)
      expect(delete_time).to eql(now.prev_hour(4))
    end

    it 'should subtract all parameters when set' do
      delete_time = AwsHelpers::Utilities::DeleteTimeBuilder.new.build(time: now, years: 1, months: 2, days: 3, hours: 4)
      expect(delete_time).to eql(now.prev_year(1).prev_month(2).prev_day(3).prev_hour(4))
    end

  end

end
