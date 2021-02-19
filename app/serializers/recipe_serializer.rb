class RecipeSerializer < ActiveModel::Serializer
  attributes :id, :title, :difficulty, :recipe_type, :cuisine, :cook_time,
             :ingredients, :cook_method, :featured

  belongs_to :recipe_type
  belongs_to :cuisine
  belongs_to :user

  def recipe_type_name
    object.recipe_type.name
  end

  def cuisine_name
    object.cuisine.name
  end
end
