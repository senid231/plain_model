# frozen_string_literal: true

require 'active_support/concern'
require 'active_support/core_ext/array/wrap'
require_relative '../merge_includes'

module PlainModel
  module Querying
    module Includes
      extend ActiveSupport::Concern

      def initialize(*args)
        super(*args)
        values[:includes] = {}
      end

      included do
        self.chainable_methods += [:includes]
      end

      # Chain method
      # @param names [Array<Symbol,Hash>] - names of includes with optional tail hash for nested includes
      # @return new instance with applied changes
      def includes(*names)
        _within_new_instance do
          new_includes = ::PlainModel::MergeIncludes.new(values[:includes]).merge(names)
          values[:includes] = new_includes
        end
      end
    end
  end
end
