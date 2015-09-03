require 'aws_helpers/s3'

include AwsHelpers::Actions::S3

describe AwsHelpers::S3 do

  let(:config) { instance_double(AwsHelpers::Config) }
  let(:s3_bucket_name) { 'bucket-name' }
  let(:acl) { 'private' }

  describe '#initialize' do

    it 'should call AwsHelpers::Client initialize method' do
      options = {endpoint: 'http://endpoint'}
      expect(AwsHelpers::Client).to receive(:new).with(options)
      AwsHelpers::S3.new(options)
    end

  end

  describe '#s3_create' do

    let(:s3_create) { instance_double(S3Create) }

    before(:each) do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(s3_create).to receive(:execute)
      allow(S3Create).to receive(:new).with(config, s3_bucket_name, acl).and_return(s3_create)
    end

    context 'default acl = private' do

      after(:each) do
        AwsHelpers::S3.new.s3_create(s3_bucket_name)
      end

      it 'should create an s3 bucket with default parameters' do
        expect(S3Create).to receive(:new).with(config, s3_bucket_name, acl).and_return(s3_create)
      end

      it 'should create an s3 bucket with default parameters' do
        expect(S3Create).to receive(:new).with(config, s3_bucket_name, acl).and_return(s3_create)
      end

      it 'should call the s3_create execute method' do
        expect(s3_create).to receive(:execute)
      end

    end

    context 'acl set to public-read' do

      let(:acl) { 'public-read' }

      it 'should create an s3 bucket with public-read' do
        expect(S3Create).to receive(:new).with(config, s3_bucket_name, acl).and_return(s3_create)
        AwsHelpers::S3.new.s3_create(s3_bucket_name, acl)
      end
    end

  end

  describe '#s3_exists?' do

    let(:s3_exists) { instance_double(S3Exists) }

    before(:each) do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(s3_exists).to receive(:execute)
      allow(S3Exists).to receive(:new).with(config, s3_bucket_name).and_return(s3_exists)
    end
    after(:each) do
      AwsHelpers::S3.new.s3_exists?(s3_bucket_name)
    end

    it 'should create the S3Exists class' do
      expect(S3Exists).to receive(:new).with(config, s3_bucket_name).and_return(s3_exists)
    end

    it 'should call the s3_exists execute method' do
      expect(s3_exists).to receive(:execute)
    end

  end

  describe '#s3_url' do

    let(:s3_url) { instance_double(S3TemplateUrl) }

    before(:each) do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(s3_url).to receive(:execute)
      allow(S3TemplateUrl).to receive(:new).with(config, s3_bucket_name).and_return(s3_url)
    end
    after(:each) do
      AwsHelpers::S3.new.s3_url(s3_bucket_name)
    end

    it 'should create the S3TemplateUrl class' do
      expect(S3TemplateUrl).to receive(:new).with(config, s3_bucket_name).and_return(s3_url)
    end

    it 'should call the s3_url execute method' do
      expect(s3_url).to receive(:execute)
    end

  end

  describe '#s3_location' do

    let(:s3_location) { instance_double(S3Location) }

    before(:each) do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(s3_location).to receive(:execute)
      allow(S3Location).to receive(:new).with(config, s3_bucket_name).and_return(s3_location)
    end
    after(:each) do
      AwsHelpers::S3.new.s3_location(s3_bucket_name)
    end

    it 'should create the s3_location class' do
      expect(S3Location).to receive(:new).with(config, s3_bucket_name).and_return(s3_location)
    end

    it 'should call the s3_location execute method' do
      expect(s3_location).to receive(:execute)
    end

  end

  describe '#upload_stack_template' do

    let(:upload_stack_template) { instance_double(S3UploadTemplate) }

    let(:stack_name) { 'my-stacke-name' }
    let(:template_json) { 'my-template' }
    let(:bucket_encrypt) { true }
    let(:template_json) { 'my-template' }

    before(:each) do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(upload_stack_template).to receive(:execute)
      allow(S3UploadTemplate).to receive(:new).with(config, stack_name, template_json, s3_bucket_name, bucket_encrypt).and_return(upload_stack_template)
    end
    after(:each) do
      AwsHelpers::S3.new.upload_stack_template(stack_name, template_json, s3_bucket_name, bucket_encrypt)
    end

    it 'should create the s3_location class' do
      expect(S3UploadTemplate).to receive(:new).with(config, stack_name, template_json, s3_bucket_name, bucket_encrypt).and_return(upload_stack_template)
    end

    it 'should call the s3_location execute method' do
      expect(upload_stack_template).to receive(:execute)
    end

  end


end
