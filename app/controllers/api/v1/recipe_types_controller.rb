class Api::V1::RecipeTypesController < Api::V1::ApplicationController
  def index
    @recipe_types = RecipeType.all
    if @recipe_types.any?
      render json: @recipe_types
    else
      render json: { message: t('errors.messages.recipe_type_not_found') },
             status: :not_found
    end
  end
end
