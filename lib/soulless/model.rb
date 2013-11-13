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
        
        def persisted?
          false
        end
    
        def save
          if valid?
            persist!
            true
          else
            false
          end
        end
    
        def update_attributes(attributes)
          self.attributes = attributes
          save
        end
    
        private
        def persist!
          raise 'Method persist! not defined...'
        end
      end
    end
  end
end