require 'aws_helpers/kms'
require 'aws_helpers/actions/kms/arn_retrieve'

describe AwsHelpers::KMS do
  let(:alias_name) { 'Batman' }
  let(:key_arn) { '123' }
  let(:request) { GatewayDeleteRequest.new(alias_name: alias_name) }
  let(:director) { instance_double(GetKeyArnDirector) }
  let(:kms_client) { instance_double(Aws::KMS::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_kms_client: kms_client) }

  before do
    allow(GetKeyArnRequest).to receive(:new).and_return(request)
    allow(GetKeyArnDirector).to receive(:new).and_return(director)
    allow(director).to receive(:get).and_return(key_arn)
  end

  describe '#initialize' do
    it 'should call AwsHelpers::Client initialize method' do
      options = { endpoint: 'http://endpoint' }
      expect(AwsHelpers::Client).to receive(:new).with(options)
      AwsHelpers::KMS.new(options)
    end
  end

  describe '#key_arn' do
    let(:kms_arn_retrieve) { instance_double(AwsHelpers::Actions::KMS::ArnRetrieve) }
    let(:alias_name) { 'alias' }

    before(:each) do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(AwsHelpers::Actions::KMS::ArnRetrieve).to receive(:new).and_return(kms_arn_retrieve)
      allow(kms_arn_retrieve).to receive(:execute)
    end

    it 'should create a GetKeyArnRequest' do
      expect(GetKeyArnRequest)
        .to receive(:new)
        .with(alias_name: alias_name)
      AwsHelpers::KMS.new.key_arn(alias_name)
    end

    it 'should create a GetKeyArnDirector' do
      expect(GetKeyArnDirector)
        .to receive(:new)
        .with(config)
      AwsHelpers::KMS.new.key_arn(alias_name)
    end

    it 'should call get on the the director' do
      expect(director)
        .to receive(:get)
        .with(request)
      AwsHelpers::KMS.new.key_arn(alias_name)
    end

    it 'should return the key arn' do
      arn = AwsHelpers::KMS.new.key_arn(alias_name)
      expect(arn).to eq(key_arn)
    end
  end
end
