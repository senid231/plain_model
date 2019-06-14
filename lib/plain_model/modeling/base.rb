# frozen_string_literal: true

require 'active_support/concern'
require 'active_model'

module PlainModel
  module Modeling
    module Base
      Column = Struct.new(:name)

      extend ActiveSupport::Concern
      include ActiveModel::Model
      include ActiveModel::Attributes

      class_methods do
        def column_names
          return @column_names if defined?(@column_names)

          @column_names = attribute_types.keys.map do |name|
            Column.new(name: name.to_sym)
          end
        end
      end
    end
  end
end
