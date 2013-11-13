module Soulless
  module Accessors
    private
    def init_accessors(attributes)
      setup_attribute_methods(attributes)
      define_attribute_accessors(attributes)
    end
    
    def setup_attribute_methods(attributes)
      self.class.define_attribute_methods(attributes)
    end
    
    def define_attribute_accessors(attributes)
      attributes.each do |attribute|
        define_reader(attribute)
        define_writer(attribute)
      end
    end
    
    def define_reader(attribute)
      self.class.send(:define_method, "#{attribute}".to_sym) do
        instance_variable_get("@#{attribute}")
      end
    end
    
    def define_writer(attribute)
      self.class.send(:define_method, "#{attribute}=".to_sym) do |value|
        define_dirty_writer(attribute, value)
        super(value)
        define_association_writer(attribute)
      end
    end
    
    def define_dirty_writer(attribute, value)
      send("#{attribute}_will_change!") unless instance_variable_get("@#{attribute}") == value
    end
    
    def define_association_writer(attribute)
      association_attributes = self.class.association_attributes
      if association_attributes && association_attributes.include?(attribute)
        association = send(attribute)
        return if association.nil?
        if association.kind_of?(Array)
          association.each { |child| child.parent = self }
        else
          association.parent = self
        end
      end
    end
  end
end