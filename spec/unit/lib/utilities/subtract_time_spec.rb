require 'aws_helpers/utilities/subtract_time'

describe AwsHelpers::Utilities::SubtractTime do

  let(:time) { Time.parse('31-Dec-2015 00:00:00') }


  it 'should simply return the time if not options given' do
    expect(subtract_time(time: time)).to be(time)
  end

  it 'should subtract two hours from 31-Dec-2015 00:00:00' do
    expect(subtract_time(time: time, hours: 2)).to eq(Time.parse('30-Dec-2015 22:00:00'))
  end

  it 'should subtract three days from 31-Dec-2015 00:00:00' do
    expect(subtract_time(time: time, days: 3)).to eq(Time.parse('28-Dec-2015 00:00:00'))
  end

  it 'should subtract four months from 31-Dec-2015 00:00:00' do
    expect(subtract_time(time: time, months: 2)).to eq(Time.parse('31-Oct-2015 00:00:00'))
  end

  it 'should subtract five years from 31-Dec-2015 00:00:00' do
    expect(subtract_time(time: time, years: 5)).to eq(Time.parse('31-Dec-2010 00:00:00'))
  end

  it 'should subtract one year, one month, one day, one hour from 31-Dec-2015 00:00:00' do
    expect(subtract_time(time: time, years: 1, months: 1, days: 1, hours: 1)).to eq(Time.parse('29-Nov-2014 23:00:00'))
  end

  def subtract_time(options = {})
    AwsHelpers::Utilities::SubtractTime.new(options).execute
  end

end
