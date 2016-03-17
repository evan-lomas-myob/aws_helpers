require 'aws-sdk-core'
require 'aws_helpers/utilities/polling_failed'

describe AwsHelpers::Utilities::PollingFailed do

  it 'should return and instance of StandardError' do
    expect(AwsHelpers::Utilities::PollingFailed.new).to be_a_kind_of(StandardError)
  end

end

describe AwsHelpers::Utilities::FailedStateError do

  it 'should return and instance of StandardError' do
    expect(AwsHelpers::Utilities::FailedStateError.new).to be_a_kind_of(StandardError)
  end

end

describe AwsHelpers::Utilities::FailedStateError do

  let(:attempts) { 5 }
  let(:response) { instance_double(AwsHelpers::Utilities::TooManyAttemptsError, "stopped waiting after #{attempts} attempts without success") }

  it 'should return and instance of PollingFailed' do
    expect(AwsHelpers::Utilities::TooManyAttemptsError.new(attempts)).to be_a_kind_of(AwsHelpers::Utilities::PollingFailed)
  end

  it 'should return a PollingFailed with message' do
    allow(AwsHelpers::Utilities::PollingFailed).to receive(:new).with(5)
    expect(AwsHelpers::Utilities::TooManyAttemptsError.new(attempts)).to be(response)
  end

  it 'should return the number of attempts' do
    expect(AwsHelpers::Utilities::TooManyAttemptsError.new(attempts).attempts).to eq(5)
  end

end

