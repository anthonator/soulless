class DummyModel < ActiveRecord::Base
  validates :name, uniqueness: true
end
