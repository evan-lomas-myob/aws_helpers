require 'aws-sdk-core'

require 'aws_helpers/config'
require 'aws_helpers/actions/kms/arn_retrieve'

describe AwsHelpers::Actions::KMS::ArnRetrieve do

  let(:kms_client) { instance_double(Aws::KMS::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_kms_client: kms_client) }
  let(:execute) { AwsHelpers::Actions::KMS::ArnRetrieve.new(config, 'first_name').execute }
  let(:response) { Aws::KMS::Types::ListAliasesResponse.new(aliases: []) }

  before(:each) {
    allow(kms_client).to receive(:list_aliases).and_return(response)
  }

  describe '#execute' do

    it 'should call Aws::KMS::Client #list_aliases with empty parameters' do
      expect(kms_client).to receive(:list_aliases)
      execute
    end

    it 'should return the correct arn that matches the alias' do
      response.aliases = [
        create_alias_entry('first_arn', 'first_name'),
        create_alias_entry('second_arn', 'second_name')
      ]
      expect(execute).to eq('first_arn')
    end

    it 'should return nil if nothing matches the alias' do
      response.aliases << create_alias_entry('second_arn', 'second_name')
      expect(execute).to be_nil
    end

  end

  def create_alias_entry(alias_arn, alias_name)
    Aws::KMS::Types::AliasListEntry.new(alias_arn: alias_arn, alias_name: "alias/#{alias_name}")
  end

end