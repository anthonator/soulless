module Soulless
  module Inheritance
    def self.included(base)
     base.instance_eval do
       def inherit_from(klass, options = {})
         attributes = get_attributes(klass, options)
         
         attributes.each do |attribute|
           self.attribute(attribute[:name], attribute[:primitive], attribute[:options])
           if Object.const_defined?('ActiveModel'.to_sym) && klass.ancestors.include?(ActiveModel::Validations)
             setup_validators(attribute[:name], klass, options)
           end
         end
       end
       
       private
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
         attribute_set.each do |attribute|
           attribute_name = attribute.options[:name].to_s
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
         columns = klass.columns
         columns.each do |column|
           if include_attribute?(column.name, options)
             attribute = {
               name: column.name,
               primitive: translate_primitive(column.type),
               options: {}
             }
             attribute[:options] = { default: column.default } if options[:use_database_default] == true ||
                                                                  options[:use_database_default] == column.name ||
                                                                  (options[:use_database_default].kind_of?(Array) &&
                                                                   options[:use_database_default].collect { |v| v.to_s }.include?(column.name))
             attributes << attribute
           end
         end
         attributes
       end
       
       def setup_validators(attribute_name, klass, options)
         return if options[:skip_validators] || !include_attribute?(attribute_name, options)
         klass.validators.each do |validator|
           if validator.attributes.include?(attribute_name.to_sym)
             validator_class = validator.class
             validator_options = {}
             validator_options.merge!(validator.options)
             if validator_class == ActiveRecord::Validations::UniquenessValidator
               validator_class = Validations::UniquenessValidator
               validator_options.merge!(model: klass)
             else
               # Validators from models are ActiveRecord
               # objects which aren't useable in an
               # environment without a database. It's
               # necessary to convert to an ActiveModel
               # validation.
               validator_class = "ActiveModel::Validations::#{validator_class.name.split('::').last}".constantize
             end
             validates_with(validator_class, { attributes: attribute_name }.merge(validator_options))
           end
         end
       end
       
       def translate_primitive(primitive)
         translated_primitive = primitive.to_s.capitalize
         translated_primitive = Virtus::Attribute::Boolean.name if translated_primitive == 'Boolean'
         translated_primitive = DateTime.name if translated_primitive == 'Datetime'
         translated_primitive.constantize
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
     end
    end
  end
end