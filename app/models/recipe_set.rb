class RecipeSet < ApplicationRecord
  belongs_to :recipe
  belongs_to :recipe_list

  validates :recipe_id, uniqueness: true
end
