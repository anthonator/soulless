module Soulless
  module Dirty
    def self.included(base)
      base.class_eval do
        def initialize(params = {})
          super
          init_dirty(attribute_set.map { |a| a.name })
        end
        
        private
        def init_dirty(attributes)
          define_dirty_attributes(attributes)
          define_dirty_methods(attributes)
          @changed_attributes = {}
        end
        
        def define_dirty_attributes(attributes)
          self.class.define_attribute_methods(attributes)
        end
        
        def define_dirty_methods(attributes)
          attributes.each do |attribute|
            define_dirty_reader(attribute)
            define_dirty_writer(attribute)
          end
        end
        
        def define_dirty_reader(name)
          self.class.send(:define_method, "#{name}".to_sym) do
            instance_variable_get("@#{name}")
          end
        end
        
        def define_dirty_writer(name)
          self.class.send(:define_method, "#{name}=".to_sym) do |value|
            send("#{name}_will_change!") unless instance_variable_get("@#{name}") == value
            super(value)
          end
        end
      end
    end
  end
end