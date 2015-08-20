require 'aws-sdk-core'
require 'aws_helpers/utilities/polling'

include AwsHelpers::Utilities::Polling

describe AwsHelpers::Utilities::Polling do

  Struct.new('PollingStatus', :status)

  let(:stdout) { instance_double(IO) }

  let(:delay) { 0 }
  let(:max_attempts) { 1 }

  let(:output) { 'Some output of state' }

  let(:response_good) { Struct::PollingStatus.new('Good') }
  let(:response_bad) { Struct::PollingStatus.new('Bad') }

  before(:each) do
    allow(stdout).to receive(:puts).with(anything)
  end

  it 'should return some output on the current status and stop' do
    expect(stdout).to receive(:puts).with("Delay = #{delay}: Max Attempts = #{max_attempts}")
    call_polling(delay, max_attempts, response_good)
  end

  it 'should exceed max_attempts and raise an exception' do
    expect{ call_polling(delay, max_attempts, response_bad) }.to raise_error("stopped waiting after #{max_attempts} attempts without success")
  end

  def call_polling(delay, max_attempts, response)
    poll(delay, max_attempts) {
      output = "Delay = #{delay}: Max Attempts = #{max_attempts}"
      stdout.puts(output)
      response.status == 'Good'
    }
  end

end