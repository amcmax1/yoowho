class Language < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :value, presence: true, uniqueness: true
end