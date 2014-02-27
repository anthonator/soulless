module Soulless
  module Model
    def self.included(base)
      base.class_eval do
        extend ActiveModel::Naming
        extend ActiveModel::Translation
        include ActiveModel::Conversion
        include ActiveModel::Dirty
        include ActiveModel::Validations
        
        class << self
          def i18n_scope
            :soulless
          end
        end
        
        def initialize(params = {})
          init_accessors(attribute_set.map { |a| a.name })
          super
          init_dirty
        end
        
        def persisted?
          false
        end
    
        def save
          if valid?
            persist!
            changes_applied
            true
          else
            false
          end
        end
        
        def assign_attributes(attributes)
          deep_update(self, attributes)
        end
    
        def update_attributes(attributes)
          assign_attributes(attributes)
          save
        end
    
        private
        def persist!
          raise 'Method persist! not defined...'
        end
        
        def deep_update(object, attributes)
          attributes.each do |key, value|
            if value.kind_of?(Hash)
              deep_update(object.send(key), value)
            else
              object.send("#{key}=", value)
            end
          end
        end
      end
    end
  end
end