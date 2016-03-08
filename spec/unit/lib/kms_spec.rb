require 'aws_helpers/kms'
require 'aws_helpers/actions/kms/arn_retrieve'

describe AwsHelpers::KMS do

  let(:config) { instance_double(AwsHelpers::Config) }

  describe '#initialize' do

    it 'should call AwsHelpers::Client initialize method' do
      options = { endpoint: 'http://endpoint' }
      expect(AwsHelpers::Client).to receive(:new).with(options)
      AwsHelpers::KMS.new(options)
    end

  end

  describe '#kms_arn' do

    let(:kms_arn_retrieve) { instance_double(AwsHelpers::Actions::KMS::ArnRetrieve) }
    let(:alias_name) { 'alias' }

    before(:each) do
      allow(AwsHelpers::Config).to receive(:new).and_return(config)
      allow(AwsHelpers::Actions::KMS::ArnRetrieve).to receive(:new).and_return(kms_arn_retrieve)
      allow(kms_arn_retrieve).to receive(:execute)
    end

    it 'should create KmsArnRetrieve #new with correct parameters' do
      expect(AwsHelpers::Actions::KMS::ArnRetrieve).to receive(:new).with(config, alias_name)
      AwsHelpers::KMS.new.key_arn(alias_name)
    end

    it 'should call KmsArnRetrieve #new execute method' do
      expect(kms_arn_retrieve).to receive(:execute)
      AwsHelpers::KMS.new.key_arn(alias_name)
    end

  end

end
