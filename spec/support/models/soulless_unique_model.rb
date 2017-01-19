require 'support/models/dummy_model'

class SoullessUniqueModel < Soulless::Model
  attribute :name, String

  validates :name, uniqueness: { model: DummyModel }
end
