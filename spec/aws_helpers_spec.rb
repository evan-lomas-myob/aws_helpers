require 'spec_helper'
require 'aws_helpers'

describe AwsHelpers do
  it 'has a version number' do
    expect(AwsHelpers::VERSION).not_to be nil
  end

  it 'has a version number the equals 0.1.0' do
    expect(AwsHelpers::VERSION).to eql('0.1.0')
  end

end
