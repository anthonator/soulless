class DummyForm
  include Soulless.model
  
  attribute :name, String
  
  validates :name, uniqueness: { model: DummyModel }
end