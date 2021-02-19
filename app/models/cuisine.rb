class Cuisine < ApplicationRecord
  has_many :recipes, dependent: :restrict_with_exception

  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: false }
end
