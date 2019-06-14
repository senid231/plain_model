# frozen_string_literal: true

module PlainModel
  class AssociationBuilder
    attr_reader :model_class, :options

    def initialize(model_class, options = {})
      @model_class = model_class
      @options = options
    end

    def load_records(name, records, context: nil, includes: [])
      apply = options.fetch(:apply) { :"_records_for_#{name}" }
      args = [records, context: context, includes: includes, association: name]
      if apply.is_a?(Symbol)
        model_class.public_send(apply, *args)
      else
        model_class.instance_exec(*args, &apply)
      end
    end
  end
end
