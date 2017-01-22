module Soulless
  module Validations
    class UsingValidator < ActiveModel::EachValidator
      def validate_each(record, attribute, value)
        check_options
        return if should_not_continue?(value)

        if value.is_a?(Array)
          value.each { |v| perform(record, attribute, v) }
        else
          perform(record, attribute, value)
        end
      end

      private

      def check_options
        fail(ArgumentError, 'The `:model` option is required for the `using` validator') unless options[:model]
        fail(ArgumentError, 'The `:model` option should contain a class that responds to `valid?` for the `using` validator') unless options[:model].respond_to?(:new) && options[:model].method_defined?(:valid?)
      end

      def should_not_continue?(value)
        (options[:allow_nil] && value.nil?) ||
          (options[:allow_empty] && value.empty?)
      end

      def perform(record, attribute, value)
        model = options[:model].new(value)

        return if model.valid?

        reference_value = model[options[:reference]] if options[:reference]

        if !reference_value.blank?
          errors = {}
          errors[reference_value] = model.errors

          record.errors[attribute] << errors
        else
          record.errors[attribute] << model.errors
        end
      end
    end
  end
end
