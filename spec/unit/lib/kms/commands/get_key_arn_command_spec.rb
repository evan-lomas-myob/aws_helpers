require 'aws_helpers/kms_commands/commands/get_key_arn_command'
require 'aws_helpers/kms_commands/requests/get_key_arn_request'

describe AwsHelpers::KMSCommands::Commands::GetKeyArnCommand do
  let(:metadata_arn) { '123' }
  let(:alias_arn) { '987' }
  let(:metadata) { Aws::KMS::Types::KeyMetadata.new(arn: metadata_arn) }
  let(:metadata_reponse) { Aws::KMS::Types::DescribeKeyResponse.new(key_metadata: metadata) }
  let(:alias_entry) { Aws::KMS::Types::AliasListEntry.new(alias_name: 'alias/Batman', alias_arn: alias_arn) }
  let(:alias_reponse) { Aws::KMS::Types::ListAliasesResponse.new(aliases: [alias_entry]) }
  let(:kms_client) { instance_double(Aws::KMS::Client) }
  let(:config) { instance_double(AwsHelpers::Config, aws_kms_client: kms_client) }
  let(:request) { AwsHelpers::KMSCommands::Requests::GetKeyArnRequest.new }

  before do
    @command = AwsHelpers::KMSCommands::Commands::GetKeyArnCommand.new(config, request)
    allow(kms_client).to receive(:list_aliases)
      .and_return(alias_reponse)
    allow(kms_client).to receive(:describe_key)
      .and_return(metadata_reponse)
  end

  it 'returns the key arn if the alias is found' do
    request.alias_name = 'Batman'
    @command.execute
    expect(request.key_arn).to eq(alias_arn)
  end

  it 'returns nil if the alias is not found' do
    request.alias_name = 'Robin'
    @command.execute
    expect(request.key_arn).to be_nil
  end

  context 'when the legacy use_key_metadata_arn key is provided' do
    before do
      request.use_key_metadata_arn = true
      request.alias_name = 'Batman'
    end
    
    it 'returns the key metadata arn' do
      @command.execute
      expect(request.key_arn).to eq(metadata_arn)
    end
  end
end
