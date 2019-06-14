# frozen_string_literal: true

require 'active_support/concern'
require 'forwardable'

module PlainModel
  module Modeling
    module Queryable
      delegate :where, :includes, :except, to: :all
      delegate :to_a, :first, :last, :each, :collect, :map, :select, :detect, to: :all

      def _query_builder
        ::PlainModel::QueryBuilder.new(self)
      end

      def all
        _query_builder
      end
    end
  end
end
