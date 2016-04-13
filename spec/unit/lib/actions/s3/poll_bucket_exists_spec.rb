require 'aws_helpers/config'
require 'aws_helpers/actions/s3/poll_bucket_exists'

describe AwsHelpers::Actions::S3::PollBucketExists do

  let(:aws_s3_client) { instance_double(Aws::S3::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_s3_client: aws_s3_client) }
  let(:stdout) { instance_double(IO) }
  let(:s3_bucket_name) { 'my-bucket' }
  let(:s3_exists) { instance_double(AwsHelpers::Actions::S3::Exists) }

  let(:delay) { 0 }
  let(:max_attempts) { 3 }

  subject do
    AwsHelpers::Actions::S3::PollBucketExists.new(config, s3_bucket_name, {stdout: stdout, delay: delay, max_attempts: max_attempts}).execute
  end

  before(:each) do
    allow(AwsHelpers::Actions::S3::Exists).to receive(:new).and_return(s3_exists)
    allow(stdout).to receive(:puts)
  end

  it 'poll that the s3 bucket exists till true' do
    expect(s3_exists).to receive(:execute).and_return(false, false, true)
    subject
  end
  it 'poll that the s3 bucket exists' do
    allow(s3_exists).to receive(:execute).and_return(false, true)
    expect(stdout).to receive(:puts).with("Waiting for S3 Bucket:#{s3_bucket_name} to be created")
    subject
  end

  it 'returns and error if max_attempts exceeded' do
    allow(s3_exists).to receive(:execute).and_return(false, false, false)
    expect { subject }.to raise_error(Aws::Waiters::Errors::TooManyAttemptsError)
  end

end
