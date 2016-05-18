class SoullessBrokenUniqueModel < Soulless::Model
  attribute :name, String

  validates :name, uniqueness: true
end
