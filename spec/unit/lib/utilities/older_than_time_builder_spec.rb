require 'aws_helpers/utilities/older_than_time_builder'
require 'aws_helpers/utilities/time'

describe AwsHelpers::Utilities::OlderThanTimeBuilder do
  let(:now) { Time.parse('31-Dec-2015 00:00:00') }

  before do
    allow(Time).to receive(:now).and_return(now)
  end

  describe '#build' do
    it 'should default to now' do
      new_time = AwsHelpers::Utilities::OlderThanTimeBuilder.new.build
      expect(new_time).to eql(now)
    end

    it 'should subtract years when set' do
      new_time = AwsHelpers::Utilities::OlderThanTimeBuilder.new.build(years: 1)
      expect(new_time).to eql(now.prev_year(1))
    end

    it 'should subtract months when set' do
      new_time = AwsHelpers::Utilities::OlderThanTimeBuilder.new.build(months: 2)
      expect(new_time).to eql(now.prev_month(2))
    end

    it 'should subtract days when set' do
      new_time = AwsHelpers::Utilities::OlderThanTimeBuilder.new.build(days: 3)
      expect(new_time).to eql(now.prev_day(3))
    end

    it 'should subtract hours when set' do
      new_time = AwsHelpers::Utilities::OlderThanTimeBuilder.new.build(hours: 4)
      expect(new_time).to eql(now.prev_hour(4))
    end

    it 'should subtract all parameters when set' do
      new_time = AwsHelpers::Utilities::OlderThanTimeBuilder.new.build(years: 1, months: 2, days: 3, hours: 4)
      expect(new_time).to eql(now.prev_year(1).prev_month(2).prev_day(3).prev_hour(4))
    end
  end
end
