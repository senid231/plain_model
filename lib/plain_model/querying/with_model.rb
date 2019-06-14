# frozen_string_literal: true

require 'active_support/concern'

module PlainModel
  module Querying
    module WithModel
      extend ActiveSupport::Concern

      def initialize(model_class, *args)
        @model_class = model_class
        super(*args)
      end

      included do
        attr_reader :model_class

        def dup_args
          [model_class]
        end

        private

        def _records
          model_class._records(values)
        end
      end
    end
  end
end
