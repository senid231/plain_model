# frozen_string_literal: true

require_relative '../association_builder'
require 'active_support/concern'
require 'active_support/core_ext/array/wrap'

module PlainModel
  module Modeling
    module Associatable
      extend ActiveSupport::Concern

      def associations
        @associations ||= {}
      end

      included do
        class_attribute :association_types, instance_writer: false, default: {}
      end

      class_methods do
        def define_association(name, options = {})
          name = name.to_s
          association_builder_class = options.fetch(:klass) { ::PlainModel::AssociationBuilder }
          association_builder = association_builder_class.new self, options.except(:klass)
          self.association_types = association_types.merge(name => association_builder)
          define_association_methods(name)
        end

        def define_association_methods(name)
          define_method(name) do
            return associations[name] if association_loaded?(name)

            associations[name] = load_association(name)
          end

          define_method("#{name}=") do |value|
            associations[name] = value
          end
        end

        def load_association(records, name, context: nil, includes: {})
          association_builder = association_types.fetch(name.to_s) do
            raise ArgumentError, "invalid association #{name}"
          end
          association_builder.load_records(name, records, context: context, includes: includes)
        end

        def load_associations(records, includes, context: nil)
          includes.each do |name, nested|
            load_association(records, name, context: context, includes: nested)
          end
        end
      end

      def association_loaded?(name)
        associations.key?(name.to_s)
      end

      def load_association(name, context: nil, includes: {})
        self.class.load_association(name, [self], context: context, includes: includes)
      end
    end
  end
end
