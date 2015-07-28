require 'spec_helper'
require 'aws_helpers'

describe AwsHelpers do
  it 'has a version number' do
    expect(AwsHelpers::VERSION).not_to be nil
  end
end
