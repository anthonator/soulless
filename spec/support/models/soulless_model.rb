class SoullessModel < Soulless::Model
  attribute :name, String, default: 'Anthony'
  attribute :email, String
  attribute :validation_callback, Boolean

  validates :name, presence: true

  before_validation lambda { self.validation_callback = true }
end
