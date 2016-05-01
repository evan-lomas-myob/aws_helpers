module AwsHelpers
  module Requests
    class Request < Struct

      def initialize(hash = {})
        hash.each do |key, value|
          self[key] = value
        end if hash
      end

      # Deeply converts the Structure into a hash.  Structure members that
      # are `nil` are omitted from the resultant hash.
      #
      # You can call #orig_to_h to get vanilla #to_h behavior as defined
      # in stdlib Struct.
      #
      # @return [Hash]
      def to_h(obj = self)
        case obj
          when Struct
            obj.members.each.with_object({}) do |member, hash|
              value = obj[member]
              hash[member] = to_hash(value) unless value.nil?
            end
          when Hash
            obj.each.with_object({}) do |(key, value), hash|
              hash[key] = to_hash(value)
            end
          when Array
            obj.collect { |value| to_hash(value) }
          else
            obj
        end
      end

      alias to_hash to_h

      class << self
        def new(*args)
          super(*args)
        end
      end
    end
  end
end
