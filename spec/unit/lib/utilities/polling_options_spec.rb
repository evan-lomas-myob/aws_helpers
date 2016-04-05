require 'aws-sdk-core'
require 'aws_helpers/utilities/polling_options'

include AwsHelpers::Utilities::PollingOptions

describe AwsHelpers::Utilities::PollingOptions do
  let(:stdout) { instance_double(IO) }

  let(:delay) { 0 }
  let(:max_attempts) { 1 }

  let(:options) { { max_attempts: max_attempts, delay: delay } }

  before(:each) do
    allow(stdout).to receive(:puts)
  end

  it 'should return an empty hash' do
    expect(create_options(nil, {})).to eq({})
  end

  it 'should return stdout with an empty hash' do
    expect(create_options(stdout, {})).to eq(stdout: stdout)
  end

  it 'should create and options hash and return it' do
    expect(create_options(stdout, options)).to eq(stdout: stdout, max_attempts: max_attempts, delay: delay)
  end
end
