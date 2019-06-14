# frozen_string_literal: true

require_relative 'modeling/base'
require_relative 'modeling/associatable'
require_relative 'modeling/queryable'

module PlainModel
  class Model
    extend PlainModel::Modeling::Queryable

    include PlainModel::Modeling::Base
    include PlainModel::Modeling::Associatable
  end
end
