require 'rspec'
require 'aws_helpers/utilities/subtract_time'

include AwsHelpers::Utilities

describe '#initialize' do

  let(:time) { Time.parse('01-Jan-2015 00:00:00' ) }

  let(:one_hour) { 1 }
  let(:one_day) { 1 }
  let(:one_month) { 1 }
  let(:one_year) { 1 }

  let(:an_hour_ago) { Time.parse('31-Dec-2014 23:00:00') }
  let(:yesterday) { Time.parse('31-Dec-2014 00:00:00') }
  let(:last_month) { Time.parse('01-Dec-2014 00:00:00') }
  let(:last_year) { Time.parse('01-Jan-2014 00:00:00') }
  let(:a_year_and_one_day) { Time.parse('31-Dec-2013 00:00:00') }
  let(:a_month_and_one_day) { Time.parse('30-Nov-2014 00:00:00') }
  let(:a_year_and_one_month) { Time.parse('01-Dec-2013 00:00:00') }

  before(:each) do
    allow(SubtractTime).to receive(:execute)
  end

  it 'should call AwsHelpers::Utilities::SubtractTime initialize method' do
    expect(SubtractTime).to receive(:new).with(time)
    SubtractTime.new(time)
  end

  it 'should simply return the time if not options given' do
    expect(SubtractTime.new(time).execute).to be(time)
  end

  it 'should subtract one hour from time' do
    expect(SubtractTime.new(time, hours: one_hour).execute).to eq(an_hour_ago)
  end

  it 'should subtract one day from time' do
    expect(SubtractTime.new(time, days: one_day).execute).to eq(yesterday)
  end

  it 'should subtract one month from time' do
    expect(SubtractTime.new(time, months: one_month).execute).to eq(last_month)
  end

  it 'should subtract one year from time' do
    expect(SubtractTime.new(time, years: one_year).execute).to eq(last_year)
  end

  it 'should subtract one day and one year from time' do
    expect(SubtractTime.new(time, days: one_day, years: one_year).execute).to eq(a_year_and_one_day)
  end

  it 'should subtract one day and one month from time' do
    expect(SubtractTime.new(time, days: one_day, months: one_month).execute).to eq(a_month_and_one_day)
  end

  it 'should subtract one year from time' do
    expect(SubtractTime.new(time, months: one_month, years: one_year).execute).to eq(a_year_and_one_month)

  end

end
