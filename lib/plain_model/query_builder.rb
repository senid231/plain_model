# frozen_string_literal: true

require_relative 'querying/base'
require_relative 'querying/with_model'
require_relative 'querying/except'
require_relative 'querying/where'
require_relative 'querying/includes'

module PlainModel
  class QueryBuilder
    include PlainModel::Querying::Base
    include PlainModel::Querying::WithModel
    include PlainModel::Querying::Except
    include PlainModel::Querying::Where
    include PlainModel::Querying::Includes
  end
end
