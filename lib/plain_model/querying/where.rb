# frozen_string_literal: true

require 'active_support/concern'

module PlainModel
  module Querying
    module Where
      extend ActiveSupport::Concern

      def initialize(*args)
        super(*args)
        values[:where] = {}
      end

      included do
        self.chainable_methods += [:except]
      end

      # Chain method
      # @param conditions [Hash]
      # @return new instance with applied changes
      def where(conditions)
        _within_new_instance do
          values[:where].merge!(conditions)
        end
      end
    end
  end
end
