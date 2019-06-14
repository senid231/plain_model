# frozen_string_literal: true

require 'active_support/concern'
require 'active_support/core_ext/class/attribute'
require 'forwardable'

module PlainModel
  module Querying
    module Base
      extend ActiveSupport::Concern

      included do
        class_attribute :chainable_methods, instance_accessor: false, default: []

        class_attribute :result_methods,
                        instance_accessor: false,
                        default: [:to_a, :first, :last, :each, :collect, :map, :select, :detect]

        extend Forwardable
        attr_reader :values
        instance_delegate [:first, :last, :each, :collect, :map, :select, :detect] => :all
        private :_within_new_instance, :_records

        def initialize(*args)
          @values = {}
          super(*args)
        end

        protected

        attr_writer :values
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

      def _within_new_instance(&block)
        new_instance = dup
        new_instance.instance_exec(&block)
        new_instance
      end

      def _records
        raise NotImplementedError, "implement #_records private method in #{self.class}"
      end
    end
  end
end
