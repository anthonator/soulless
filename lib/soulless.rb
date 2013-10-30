require 'virtus'
require 'active_support/core_ext/class/attribute'
require 'active_support/core_ext/module/delegation'
require 'active_support/callbacks'
require 'active_support/concern'
require 'active_model/naming'
require 'active_model/translation'
require 'active_model/callbacks'
require 'active_model/validator'
require 'active_model/errors'
require 'active_model/validations'
require 'active_model/conversion'

require 'soulless/model'
require 'soulless/version'

module Soulless
  def self.model(options = {})
    mod = Module.new
    mod.define_singleton_method :included do |object|
      object.send(:include, Virtus.model(options))
      object.send(:include, Model)
    end
    mod
  end
end
