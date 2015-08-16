require 'aws_helpers/utilities/time'

describe Time do

  let(:time) { Time.parse('31-Dec-2015 00:00:00') }

  describe '#prev_hour' do

    it 'should return the time if nil given' do
      expect(time.prev_hour(nil)).to eql(time)
    end

    it 'should subtract two hours from 31-Dec-2015 00:00:00' do
      expect(time.prev_hour(2)).to eql(Time.parse('30-Dec-2015 22:00:00'))
    end

  end

  describe '#prev_day' do

    it 'should return the time if nil given' do
      expect(time.prev_day(nil)).to eql(time)
    end

    it 'should subtract three days from 31-Dec-2015 00:00:00' do
      expect(time.prev_day(3)).to eql(Time.parse('28-Dec-2015 00:00:00'))
    end

  end

  describe '#prev_month' do

    it 'should return the time if nil given' do
      expect(time.prev_month(nil)).to eql(time)
    end

    it 'should subtract two months from 31-Dec-2015 00:00:00' do
      expect(time.prev_month(2)).to eql(Time.parse('31-Oct-2015 00:00:00'))
    end

  end

  describe '#prev_year' do

    it 'should return the time if nil given' do
      expect(time.prev_year(nil)).to eql(time)
    end

    it 'should subtract five years from 31-Dec-2015 00:00:00' do
      expect(time.prev_year(5)).to eql(Time.parse('31-Dec-2010 00:00:00'))
    end

  end

end
