class DummyModel < ActiveRecord::Base
  validates :name, presence: true,
                   uniqueness: true

  validates :email, length: { minimum: 3, allow_blank: true }
end