require 'aws_helpers'

describe AwsHelpers::Actions::CloudFormation::StackParameterUpdateBuilder do


  describe '#execute' do

    let(:stack_name) { 'name' }

    context 'existing parameters are empty' do

      it 'should return nil if the existing stack has empty parameters' do
        stack = Aws::CloudFormation::Types::Stack.new(stack_name: stack_name, parameters: [])
        expect(described_class.new(stack_name, stack, [{parameter_key: 'key', parameter_value: 'new_value'}]).execute).to eq(nil)
      end

    end

    context 'existing parameters are not empty' do

      let(:stack) { Aws::CloudFormation::Types::Stack.new(stack_name: stack_name, parameters: [create_parameter('key', 'value')], capabilities: ['CAPABILITY']) }

      context 'new parameters have a different value' do

        let(:parameters) { [{parameter_key: 'key', parameter_value: 'new_value'}] }

        it 'should return a hash the capabilities set from existing stack parameters' do
          expect(described_class.new(stack_name, stack, parameters).execute[:capabilities]).to eq(['CAPABILITY'])
        end

        it 'should return a hash with :stack_name set' do
          expect(described_class.new(stack_name, stack, parameters).execute[:stack_name]).to eq(stack_name)
        end

        it 'should return a hash with :use_previous_template true' do
          expect(described_class.new(stack_name, stack, parameters).execute[:use_previous_template]).to eq(true)
        end

        it 'should return a hash with :parameters of the value to change' do
          expect(described_class.new(stack_name, stack, parameters).execute[:parameters]).to eq(parameters)
        end

      end

      context 'new parameters have the same value' do

        let(:parameters) { [{parameter_key: 'key', parameter_value: 'value'}] }

        it 'should return a hash with :parameters of the value that has not changed with :use_previous_value' do
          expect(described_class.new(stack_name, stack, parameters).execute[:parameters]).to eq([{parameter_key:'key', use_previous_value:true}])
        end

      end

    end

  end

  def create_parameter(key, value, use_previous_value: true)
    Aws::CloudFormation::Types::Parameter.new(parameter_key: key, parameter_value: value, use_previous_value: use_previous_value)
  end

end


