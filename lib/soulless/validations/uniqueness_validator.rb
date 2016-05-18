module Soulless
  module Validations
    class UniquenessValidator < ActiveModel::EachValidator
      def initialize(options)
        raise 'ActiveRecord is not defined. The Soulless uniqueness validator cannot be used when ActiveRecord is not present.' unless Object.const_defined?('ActiveRecord')
        @model = options[:model]
        @attribute = options[:attribute]
        options.merge!(class: @model)
        @validator = ActiveRecord::Validations::UniquenessValidator.new(options)
        super(options)
      end

      def validate_each(record, attribute, value)
        if !@model
          raise ArgumentError, 'Missing required argument "model"'
        else
          record_orig, attribute_orig = record, attribute

          attribute = @attribute if @attribute
          record = @model.new(attribute => value)

          @validator.validate_each(record, attribute, value)

          if record.errors.any?
            record_orig.errors.add(attribute, :taken, options.except(:case_sensitive, :scope).merge(value: value))
          end
        end
      end
    end

    module ClassMethods
      def validates_uniqueness_of(*attr_name)
        validates_with(UniquenessValidator, _merge_attributes(attr_name))
      end
    end
  end
end
