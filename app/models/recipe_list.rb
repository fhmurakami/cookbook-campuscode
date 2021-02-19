class RecipeList < ApplicationRecord
  belongs_to :user
  has_many :recipe_sets, dependent: :destroy
  has_many :recipes, through: :recipe_sets

  validates :name, presence: true

  def recipe?(recipe)
    return true if recipes.include? recipe

    false
  end
end
