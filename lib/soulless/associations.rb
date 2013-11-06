module Soulless
  module Associations
    def self.included(base)
      base.instance_eval do |object|
        def has_one(name, superclass = Object, &block)
          klass = define_virtus_class(name, superclass, &block)
          send(:attribute, name, klass)
        end
        
        def has_many(name, superclass = Object, &block)
          klass = define_virtus_class(name, superclass, &block)
          send(:attribute, name, Array[klass])
        end
        
        private
        def define_virtus_class(name, superclass, &block)
          klass_name = name.to_s.singularize.classify + '_' + SecureRandom.hex
          klass = const_set(klass_name, Class.new(superclass))
          klass.send(:include, Soulless.model) unless klass.included_modules.include?(Model)
          klass.instance_eval(&block) if block_given?
          klass.model_name.instance_variable_set(:@i18n_key, klass.model_name.i18n_key.to_s.gsub(/_[^_]+$/, '').underscore.to_sym)
          klass
        end
      end
    end
  end
end