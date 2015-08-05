require 'rspec'
require 'aws_helpers/utilities/subtract_time'

include AwsHelpers::Utilities

describe '#initialize' do

  let(:time) { Time.new(2015, 01, 01, 0, 0, 0 ) }

  let(:one_hour) { 1 }
  let(:one_day) { 1 }
  let(:one_month) { 1 }
  let(:one_year) { 1 }

  let(:an_hour_ago) { Time.new(2014, 12, 31, 23, 0, 0) }
  let(:yesterday) { Time.new(2014, 12, 31) }
  let(:last_month) { Time.new(2014, 12, 01) }
  let(:last_year) { Time.new(2014, 01, 01) }
  let(:a_year_and_one_day) { Time.new(2013, 12, 31) }
  let(:a_month_and_one_day) { Time.new(2014, 11, 30) }
  let(:a_year_and_one_month) { Time.new(2013, 12, 01) }

  before(:each) do
    allow(SubtractTime).to receive(:execute)
  end

  it 'should call AwsHelpers::Utilities::SubtractTime initialize method' do
    expect(SubtractTime).to receive(:new).with(time)
    SubtractTime.new(time)
  end

  it 'should simply return the time if not options given' do
    expect(SubtractTime.new(time, hours: nil, days: nil, months: nil, years: nil).execute).to be(time)
  end

  it 'should subtract one hour from time' do
    expect(SubtractTime.new(time, hours: one_hour, days: nil, months: nil, years: nil).execute).to eq(an_hour_ago)
  end

  it 'should subtract one day from time' do
    expect(SubtractTime.new(time, hours: nil, days: one_day, months: nil, years: nil).execute).to eq(yesterday)
  end

  it 'should subtract one month from time' do
    expect(SubtractTime.new(time, hours: nil, days: nil, months: one_month, years: nil).execute).to eq(last_month)
  end

  it 'should subtract one year from time' do
    expect(SubtractTime.new(time, hours: nil, days: nil, months: nil, years: one_year).execute).to eq(last_year)
  end

  it 'should subtract one day and one year from time' do
    expect(SubtractTime.new(time, hours: nil, days: one_day, months: nil, years: one_year).execute).to eq(a_year_and_one_day)
  end

  it 'should subtract one day and one month from time' do
    expect(SubtractTime.new(time, hours: nil, days: one_day, months: one_month, years: nil).execute).to eq(a_month_and_one_day)
  end

  it 'should subtract one year from time' do
    expect(SubtractTime.new(time, hours: nil, days: nil, months: one_month, years: one_year).execute).to eq(a_year_and_one_month)

  end

end
