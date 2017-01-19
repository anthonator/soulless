require 'support/models/soulless_model'

class DummyModel < ActiveRecord::Base
  serialize :soulless, ::SoullessModel

  validates :name, uniqueness: true
end
