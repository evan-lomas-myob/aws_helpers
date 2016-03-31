module AwsHelpers
  module Utilities
    class TargetStackValidate
      def execute(options)
        @target_stack = options[:stack_name] || options[:stack_id]
        raise 'You must supply and options[:stack_name] or options[:stack_id]' if @target_stack.nil?
        @target_stack
      end
    end
  end
end
