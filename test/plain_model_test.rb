# frozen_string_literal: true

require 'test_helper'

class Employee < ::PlainModel::Model
  attribute :id, :integer
  attribute :name
  attribute :hired_at, :time, default: -> { Time.now }

  attr_accessor :_query

  define_association :boss
  define_association :colleagues
  define_association :pets

  def self._records(options)
    records = %w[1 2].map do |id|
      new(id: id, name: 'John', _query: options)
    end
    load_associations records, options[:includes]
    records
  end

  def self._records_for_boss(records, options)
    boss = new(id: '3', name: 'Jake', _query: options)
    records.each { |record| record.boss = boss }
  end

  def self._records_for_colleagues(records, options)
    colleagues = [
        new(id: '4', name: 'Jane', _query: options),
        new(id: '5', name: 'James', _query: options)
    ]
    records.each { |record| record.colleagues = colleagues }
  end
end

class PlainModelTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::PlainModel::VERSION
  end

  def test_my_model
    records = Employee.where(name: 'John', hired: true).includes(:boss, colleagues: :boss).to_a
    assert_equal 2, records.size

    record = records.first
    assert_kind_of Employee, record
    assert_equal 1, record.id
    assert_equal 'John', record.name
    expected_query = {
        where: { name: 'John', hired: true },
        includes: { boss: {}, colleagues: { boss: {} } }
    }
    assert_equal expected_query, record._query

    boss = record.boss
    assert_kind_of Employee, boss
    assert_equal 3, boss.id
    assert_equal 'Jake', boss.name
    expected_boss_query = { context: nil, includes: {}, association: :boss }
    assert_equal expected_boss_query, boss._query

    colleagues = record.colleagues
    assert_equal 2, colleagues.size

    colleague = colleagues.first
    assert_kind_of Employee, colleague
    assert_equal 4, colleague.id
    assert_equal 'Jane', colleague.name
    expected_colleague_query = { context: nil, includes: { boss: {} }, association: :colleagues }
    assert_equal expected_colleague_query, colleague._query
  end

  def test_merge_includes
    old_includes = {}
    new_includes = [:foo, :baz, bar: :baz, qwe: [:asd, :zxc], foo: { baz: { asd: [:qwe] } }]
    result = ::PlainModel::MergeIncludes.new(old_includes).merge(new_includes)
    expected_result = {
        foo: {
            baz: {
                asd: {
                    qwe: {}
                }
            }
        },
        bar: { baz: {} },
        baz: {},
        qwe: {
            asd: {},
            zxc: {}
        }
    }
    assert_equal expected_result, result
  end
end
