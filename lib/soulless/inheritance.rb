module Soulless
  module Inheritance
    def inherit_from(klass, options = {})
      attributes = get_attributes(klass, options)

      attributes.each do |attribute|
        self.attribute(attribute[:name], attribute[:primitive], attribute[:options])
        if Object.const_defined?('ActiveModel'.to_sym) && klass.ancestors.include?(ActiveModel::Validations)
          setup_validators(attribute[:name], klass, options)
        end
      end
    end

    def get_attributes(klass, options)
      if klass.ancestors.include?(Virtus::Model::Core)
        get_virtus_attributes(klass, options)
      elsif Object.const_defined?('ActiveRecord'.to_sym) && klass.ancestors.include?(ActiveRecord::Base)
        get_active_record_attributes(klass, options)
      end
    end

    def get_virtus_attributes(klass, options)
      attributes = []
      attribute_set = klass.attribute_set
      attribute_names = get_attribute_names(attribute_set.map{ |a| a.options[:name] }, options)
      attribute_names.each do |attribute_name|
        attribute = attribute_set[attribute_name]
        if include_attribute?(attribute_name, options)
          attributes << {
            name: attribute_name,
            primitive: attribute.primitive,
            options: {
              default: attribute.default_value
            }
          }
        end
      end
      attributes
    end

    def get_active_record_attributes(klass, options)
      attributes = []
      attribute_names = get_attribute_names(klass.attribute_names.dup, options)
      attribute_names.each do |attribute_name|
        if include_attribute?(attribute_name, options)
          column = klass.columns_hash[attribute_name.to_s]
          attribute = {
            name: attribute_name,
            primitive: String,
            options: {}
          }
          attribute[:primitive] = translate_primitive(column.type) if column
          attribute[:options] = { default: column.default } if column &&
                                                               (options[:use_database_default] == true ||
                                                                 options[:use_database_default] == attribute_name ||
                                                                 (options[:use_database_default].kind_of?(Array) &&
                                                                   options[:use_database_default].collect { |v| v.to_s }.include?(attribute_name)))
          attributes << attribute
        end
      end
      attributes
    end

    def setup_validators(attribute_name, klass, options)
      return if skip_validators?(attribute_name, options) || !include_attribute?(attribute_name, options)
      klass.validators.each do |validator|
        if validator.attributes.include?(attribute_name.to_sym)
          validator_class = validator.class
          validator_options = {}
          validator_options.merge!(validator.options)
          next if validator_options.include?(:on) && options["validate_#{attribute_name}_on".to_sym] != validator_options[:on]
          validator_options.delete(:on)
          if validator_class.name == 'ActiveRecord::Validations::UniquenessValidator'
            validator_class = Validations::UniquenessValidator
            validator_options.merge!(model: klass)
          else
            # Validators from models are ActiveRecord
            # objects which aren't useable in an
            # environment without a database. It's
            # necessary to convert to an ActiveModel
            # validation.
            if validator_class.name =~ /\AActiveRecord/
              validator_class = "ActiveModel::Validations::#{validator_class.name.split('::').last}".constantize
            end
          end
          validates_with(validator_class, { attributes: attribute_name }.merge(validator_options))
        end
      end
    end

    def get_attribute_names(attributes, options)
      attribute_names = attributes
      attribute_names << options[:additional_attributes] if options[:additional_attributes]
      attribute_names.flatten!
      attribute_names.map!{ |a| a.to_s }
      attribute_names
    end

    def translate_primitive(primitive)
      return nil unless primitive
      translated_primitive = primitive.to_s.capitalize
      translated_primitive = Virtus::Attribute::Boolean if translated_primitive == 'Boolean'
      translated_primitive = DateTime if translated_primitive == 'Datetime'
      translated_primitive = String if translated_primitive == 'Uuid'
      translated_primitive = BigDecimal if translated_primitive == 'Decimal'
      translated_primitive
    end

    def include_attribute?(attribute_name, options)
      # Attributes we don't want to inherit
      exclude_attributes = ['id']
      exclude_attributes << ['created_at', 'updated_at'] unless options[:include_timestamps]
      exclude_attributes << options[:exclude] if options[:exclude]
      exclude_attributes.flatten!
      exclude_attributes.collect!{ |v| v.to_s }
      # Attributes we only want to inherit
      only_attributes = []
      only_attributes << options[:only] if options[:only]
      only_attributes.flatten!
      only_attributes.collect!{ |v| v.to_s }

      !exclude_attributes.include?(attribute_name) && (only_attributes.empty? || only_attributes.include?(attribute_name))
    end

    def skip_validators?(attribute_name, options)
      return true if options[:skip_validators] == true
      skip_validators = []
      skip_validators << options[:skip_validators]
      skip_validators.flatten!
      skip_validators.collect!{ |v| v.to_s }
      skip_validators.include?(attribute_name)
    end
  end
end
