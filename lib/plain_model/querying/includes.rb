# frozen_string_literal: true

require 'active_support/concern'
require 'active_support/core_ext/array/wrap'
require_relative '../merge_includes'

module PlainModel
  module Querying
    module Includes
      extend ActiveSupport::Concern

      def initial_values
        super.merge includes: {}
      end

      # Chain method
      # @param names [Array<Symbol,Hash>] - names of includes with optional tail hash for nested includes
      # @return new instance with applied changes
      def includes(*names)
        dup.includes!(*names)
      end

      # Chain method
      # @param names [Array<Symbol,Hash>] - names of includes with optional tail hash for nested includes
      # @return current instance with applied changes
      def includes!(*names)
        new_includes = ::PlainModel::MergeIncludes.new(values[:includes]).merge(names)
        values[:includes] = new_includes
        self
      end
    end
  end
end
