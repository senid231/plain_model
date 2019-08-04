# frozen_string_literal: true

require 'active_support/concern'

module PlainModel
  module Querying
    module WithModel
      extend ActiveSupport::Concern

      included do
        attr_reader :model_class
        private :_records
      end

      def initialize(model_class, *args)
        @model_class = model_class
        super(*args)
      end

      def dup_args
        super + [model_class]
      end

      def _records
        model_class._records(values)
      end

    end
  end
end
