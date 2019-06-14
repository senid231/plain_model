# frozen_string_literal: true

module PlainModel
  class MergeIncludes
    def initialize(old_values)
      @old_values = old_values
    end

    def merge(new_values)
      normalized = normalize_values(new_values)
      @old_values.dup.deep_merge(normalized)
    end

    private

    # Converts includes into hash structure.
    # In this structure key is a include name and value is a nested hash structure for this include.
    # It allows to merge and parse includes with ease.
    # example:
    #   new_values => [:foo, :baz, bar: :baz, qwe: [:asd, :zxc], foo: { baz: { asd: [:qwe] } }]
    #   normalize_values(new_values) =>
    #   {
    #     foo: {
    #       baz: {
    #         asd: {
    #           qwe: {}
    #         }
    #       }
    #     },
    #     bar: { baz: {} },
    #     baz: {},
    #     qwe: {
    #       asd: {},
    #       zxc: {}
    #     }
    #   }
    def normalize_values(new_values)
      new_values = Array.wrap(new_values)
      return {} if new_values.empty? || (new_values.size == 1 && new_values.first == {})

      normalized = {}
      new_values.each do |value|
        value = value.to_sym if value.is_a?(String)
        value = { value => {} } unless value.is_a?(Hash)
        value.each do |value_key, value_values|
          value_key = value_key.to_sym if value_key.is_a?(String)
          normalized[value_key] = normalized.fetch(value_key, {}).deep_merge(normalize_values(value_values))
        end
      end
      normalized
    end
  end
end
