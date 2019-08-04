# frozen_string_literal: true

require 'active_support/concern'
require 'active_support/core_ext/class/attribute'
require 'forwardable'

module PlainModel
  module Querying
    module Base
      extend ActiveSupport::Concern

      included do
        extend Forwardable
        attr_accessor :values
        instance_delegate [:first, :last, :each, :collect, :map, :filter, :detect] => :to_a
        private :_records
      end

      def initialize(*args)
        @values = initial_values
        super(*args)
      end

      def initial_values
        {}
      end

      def to_a
        return @to_a if defined?(@to_a)

        @to_a = _records
      end

      def dup
        new_instance = self.class.new(*dup_args)
        new_instance.values = values.dup
        new_instance
      end

      def dup_args
        []
      end

      def _records
        raise NotImplementedError, "implement #_records private method in #{self.class}"
      end
    end
  end
end
