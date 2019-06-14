# frozen_string_literal: true

require 'active_support/concern'

module PlainModel
  module Querying
    module Except
      extend ActiveSupport::Concern

      # Chain method
      # @param keys [Array<Symbol>] values keys that you want to exclude from query
      # @return new instance with applied changes
      def except(*keys)
        _within_new_instance do
          self.values = values.except(*keys)
        end
      end

      included do
        self.chainable_methods += [:except]
      end
    end
  end
end
