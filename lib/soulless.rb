require 'virtus'
require 'securerandom'
require 'active_support'
require 'active_model'

require 'soulless/accessors'
require 'soulless/associations'
require 'soulless/dirty'
require 'soulless/inheritance'
require 'soulless/model'
require 'soulless/validations'
require 'soulless/version'

require 'soulless/railtie' if defined?(Rails)

module Soulless
  I18n.load_path += Dir.glob('lib/soulless/locale/*.{rb,yml}')
  
  def self.model(options = {})
    mod = Module.new
    mod.define_singleton_method :included do |object|
      object.send(:include, Virtus.model(options))
      object.send(:include, Model)
      object.send(:include, Associations)
      object.send(:include, Validations)
      object.send(:include, Dirty)
      object.send(:include, Accessors)
      object.send(:include, Inheritance)
    end
    mod
  end
end
