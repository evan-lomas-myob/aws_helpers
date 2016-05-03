require 'aws_helpers/s3'

describe AwsHelpers::S3 do
  let(:config) { instance_double(AwsHelpers::Config) }
  let(:s3_bucket_name) { 'my_group_name' }

  describe '#initialize' do
    it 'should call AwsHelpers::Client initialize method' do
      options = {endpoint: 'http://endpoint'}
      expect(AwsHelpers::Client).to receive(:new).with(options)
      AwsHelpers::S3.new(options)
    end
  end

  describe '#create' do
    let(:bucket_create_director) { instance_double(AwsHelpers::Directors::S3::BucketCreateDirector) }

    let(:bucket_name) { 'bucket_name' }
    let(:acl) { 'acl' }
    let(:stdout) { instance_double(IO) }
    let(:delay) { 1 }
    let(:max_attempts) { 2 }

    before(:each) do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(AwsHelpers::Directors::S3::BucketCreateDirector).to receive(:new).and_return(bucket_create_director)
      allow(bucket_create_director).to receive(:create)
    end

    it 'should call AwsHelpers::Directors::S3::BucketCreateDirector #new with correct parameters' do
      expect(AwsHelpers::Directors::S3::BucketCreateDirector).to receive(:new).with(config)
      AwsHelpers::S3.new.bucket_create(bucket_name)
    end

    it 'should AwsHelpers::Directors::S3::BucketCreateDirector #create with required parameters' do
      request = AwsHelpers::Requests::S3::BucketCreateRequest.new(
          bucket_name: bucket_name)
      expect(bucket_create_director).to receive(:create).with(request)
      AwsHelpers::S3.new.bucket_create(bucket_name)
    end

    it 'should AwsHelpers::Directors::S3::BucketCreateDirector #create with optional stdout' do
      request = AwsHelpers::Requests::S3::BucketCreateRequest.new(
          stdout: stdout,
          bucket_name: bucket_name)
      expect(bucket_create_director).to receive(:create).with(request)
      AwsHelpers::S3.new.bucket_create(bucket_name, stdout: stdout)
    end

    it 'should AwsHelpers::Directors::S3::BucketCreateDirector #create with optional acl' do
      request = AwsHelpers::Requests::S3::BucketCreateRequest.new(
          bucket_acl: acl,
          bucket_name: bucket_name)
      expect(bucket_create_director).to receive(:create).with(request)
      AwsHelpers::S3.new.bucket_create(bucket_name, acl: acl)
    end

    it 'should AwsHelpers::Directors::S3::BucketCreateDirector #create with optional bucket_polling delay' do
      request = AwsHelpers::Requests::S3::BucketCreateRequest.new(
          bucket_polling: AwsHelpers::Requests::PollingRequest.new(delay: delay),
          bucket_name: bucket_name)
      expect(bucket_create_director).to receive(:create).with(request)
      AwsHelpers::S3.new.bucket_create(bucket_name, bucket_polling: {delay: delay})
    end

    it 'should AwsHelpers::Directors::S3::BucketCreateDirector #create with optional bucket_polling max_attempts' do
      request = AwsHelpers::Requests::S3::BucketCreateRequest.new(
          bucket_polling: AwsHelpers::Requests::PollingRequest.new(max_attempts: max_attempts),
          bucket_name: bucket_name)
      expect(bucket_create_director).to receive(:create).with(request)
      AwsHelpers::S3.new.bucket_create(bucket_name, bucket_polling: {max_attempts: max_attempts})
    end

    it 'should return nil' do
      expect(AwsHelpers::S3.new.bucket_create(bucket_name)).to eq(nil)
    end
  end

  describe '#exists?' do
    let(:bucket_exists_director) { instance_double(AwsHelpers::Directors::S3::BucketExistsDirector) }
    let(:bucket_name) { 'bucket_name' }
    let(:exists) { true }

    before(:each) do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(AwsHelpers::Directors::S3::BucketExistsDirector).to receive(:new).and_return(bucket_exists_director)
      allow(bucket_exists_director).to receive(:exists?).and_return(exists)
    end

    it 'should call AwsHelpers::Directors::S3::BucketCreateDirector #new with correct parameters' do
      expect(AwsHelpers::Directors::S3::BucketExistsDirector).to receive(:new).with(config)
      AwsHelpers::S3.new.bucket_exists?(bucket_name)
    end

    it 'should AwsHelpers::Directors::S3::BucketExistsDirector #exists? with required parameters' do
      request = AwsHelpers::Requests::S3::BucketExistsRequest.new(
          bucket_name: bucket_name)
      expect(bucket_exists_director).to receive(:exists?).with(request)
      AwsHelpers::S3.new.bucket_exists?(bucket_name)
    end

    it 'should return a boolean value' do
      expect(AwsHelpers::S3.new.bucket_exists?(bucket_name)).to eq(exists)
    end
  end

end
