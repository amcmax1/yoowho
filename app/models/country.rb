class Country < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_many :persons, foreign_key: :country_id
end