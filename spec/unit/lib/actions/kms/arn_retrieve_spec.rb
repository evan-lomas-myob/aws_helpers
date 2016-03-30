require 'aws-sdk-core'

require 'aws_helpers/config'
require 'aws_helpers/actions/kms/arn_retrieve'

describe AwsHelpers::Actions::KMS::ArnRetrieve do
  let(:kms_client) { instance_double(Aws::KMS::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_kms_client: kms_client) }
  let(:execute) { AwsHelpers::Actions::KMS::ArnRetrieve.new(config, 'first_name').execute }
  let(:list_aliases_response) { Aws::KMS::Types::ListAliasesResponse.new(aliases: []) }
  let(:describe_key_response) { Aws::KMS::Types::DescribeKeyResponse.new(key_metadata: nil) }

  before(:each) do
    allow(kms_client).to receive(:list_aliases).and_return(list_aliases_response)
    allow(kms_client).to receive(:describe_key).and_return(describe_key_response)
  end

  describe '#execute' do
    it 'should call Aws::KMS::Client #list_aliases with empty parameters' do
      expect(kms_client).to receive(:list_aliases)
      arn_retrieve(config, 'first_name')
    end

    it 'should call Aws::KMS::Client #describe_key with correct key_id when the use_key_metadata_arn: option is supplied' do
      list_aliases_response.aliases << create_alias_entry('first_arn', 'first_name', 'first_key_id')
      describe_key_response.key_metadata = create_key_metadata('guid_arn')
      expect(kms_client).to receive(:describe_key).with(key_id: 'first_key_id')
      arn_retrieve(config, 'first_name', use_key_metadata_arn: true)
    end

    it 'should return the guid arn when use_key_metadata_arn: option is supplied' do
      list_aliases_response.aliases << create_alias_entry('first_arn', 'first_name', 'first_key_id')
      describe_key_response.key_metadata = create_key_metadata('guid_arn')
      expect(arn_retrieve(config, 'first_name', use_key_metadata_arn: true)).to eq('guid_arn')
    end

    it 'should return the correct arn that matches the alias' do
      list_aliases_response.aliases = [
        create_alias_entry('first_arn', 'first_name', 'first_key_id'),
        create_alias_entry('second_arn', 'second_name', 'second_key_id')
      ]
      expect(arn_retrieve(config, 'first_name')).to eq('first_arn')
    end

    it 'should return nil if nothing matches the alias' do
      list_aliases_response.aliases << create_alias_entry('second_arn', 'second_name', 'second_key_id')
      expect(arn_retrieve(config, 'first_name')).to be_nil
    end
  end

  def arn_retrieve(config, alias_name, options = {})
    AwsHelpers::Actions::KMS::ArnRetrieve.new(config, alias_name, options).execute
  end

  def create_key_metadata(guid_arn)
    Aws::KMS::Types::KeyMetadata.new(arn: guid_arn)
  end

  def create_alias_entry(alias_arn, alias_name, target_key_id)
    Aws::KMS::Types::AliasListEntry.new(alias_arn: alias_arn, alias_name: "alias/#{alias_name}", target_key_id: target_key_id)
  end
end
