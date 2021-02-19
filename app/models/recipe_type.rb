class RecipeType < ApplicationRecord
  has_many :recipes, dependent: :restrict_with_exception

  validates :name, presence: true
  validates :name, uniqueness: { message: 'Tipo de receita já existente',
                                 case_sensitive: false }
end
