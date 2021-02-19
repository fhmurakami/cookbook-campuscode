class Api::V1::RecipesController < Api::V1::ApplicationController
  before_action :authenticate_with_token!, only: %i[create destroy update]
  def all
    @recipes = Recipe.all
    if @recipes.any?
      render json: @recipes
    else
      render json: { message: t('errors.messages.recipe_not_found') },
             status: :not_found
    end
  end

  def create
    recipe = current_user.recipes.new(recipe_params)
    if recipe.save
      render json: recipe, status: :created
    else
      render json: { errors: recipe.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    recipe = current_user.recipes.find(params[:id])
    recipe.destroy
    head :no_content
  end

  def show
    recipe = Recipe.find(params[:id])
    render json: recipe
  rescue ActiveRecord::RecordNotFound
    render json: { message: t('errors.messages.recipe_not_found') },
           status: :not_found
  end

  def update
    recipe = current_user.recipes.find(params[:id])

    if recipe.update(recipe_params)
      render json: recipe, status: :ok
    else
      render json: { errors: recipe.errors }, status: :unprocessable_entity
    end
  end

  private

  def recipe_params
    params.require(:recipe).permit(:title, :recipe_type_id, :cuisine_id,
                                   :difficulty, :cook_time, :ingredients,
                                   :cook_method, :photo)
  end
end
