module Soulless
  module Attributes
    module ClassMethods
      def attribute(name, type = nil, options = {})
        super(name, type, options) if super

        define_attribute_methods(name)

        define_reader(name)
        define_writer(name)
      end

      def define_reader(attribute)
        define_method(attribute.to_sym) do
          attribute_set[attribute.to_sym].get(self)
        end
      end

      def define_writer(attribute)
        define_method("#{attribute}=".to_sym) do |value|
          send("#{attribute}_will_change!") unless value == attribute_set[attribute.to_sym].get(self)
          super(value)
        end
      end
    end

    def self.prepended(base)
      class << base
        prepend ClassMethods
      end
    end
  end
end
