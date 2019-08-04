# frozen_string_literal: true

require 'active_support/concern'

module PlainModel
  module Querying
    module Where
      extend ActiveSupport::Concern

      def initial_values
        super.merge where: []
      end

      # Chain method
      # @param conditions [Array]
      # @return new instance with applied changes
      def where(*conditions)
        dup.where!(*conditions)
      end

      # Chain method
      # @param conditions [Array]
      # @return current instance with applied changes
      def where!(*conditions)
        values[:where] = (values[:where] + conditions).uniq
        self
      end
    end
  end
end
