require 'aws_helpers/s3'

describe AwsHelpers::S3 do
  let(:config) { instance_double(AwsHelpers::Config) }
  let(:s3_bucket_name) { 'my_group_name' }

  describe '#initialize' do
    it 'should call AwsHelpers::Client initialize method' do
      options = { endpoint: 'http://endpoint' }
      expect(AwsHelpers::Client).to receive(:new).with(options)
      AwsHelpers::S3.new(options)
    end
  end

  describe '#create' do
    let(:s3_create) { instance_double(Create) }

    before(:each) do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(Create).to receive(:new).and_return(s3_create)
      allow(s3_create).to receive(:execute).and_return(nil)
    end

    subject { AwsHelpers::S3.new.create(s3_bucket_name) }

    it 'should create S3Create with correct parameters' do
      expect(Create).to receive(:new).with(config, s3_bucket_name, {})
      subject
    end

    it 'should call S3Create execute method' do
      expect(s3_create).to receive(:execute)
      subject
    end

    it 'should return nil' do
      expect(s3_create.execute).to eq(nil)
    end
  end

  describe '#exists?' do
    let(:exists) { instance_double(Exists) }

    before(:each) do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(Exists).to receive(:new).and_return(exists)
      allow(exists).to receive(:execute).and_return(false)
    end

    subject { AwsHelpers::S3.new.exists?(s3_bucket_name) }

    it 'should create S3Exists with correct parameters' do
      expect(Exists).to receive(:new).with(config, s3_bucket_name)
      subject
    end

    it 'should call S3Create execute method' do
      expect(exists).to receive(:execute)
      subject
    end

    it 'should return nil' do
      expect(exists.execute).to eq(false)
    end
  end

end
