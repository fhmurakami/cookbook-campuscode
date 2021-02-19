class RecipeTypesController < ApplicationController
  before_action :set_recipe_type, only: %i[show edit update destroy]
  before_action :authenticate_user!, only: %i[new create edit update destroy]
  before_action :user_admin?, only: %i[new create edit update destroy]

  def new
    @recipe_type = RecipeType.new
  end

  def create
    @recipe_type = RecipeType.new(recipe_type_params)
    if @recipe_type.save
      redirect_to @recipe_type
    else
      render :new
    end
  end

  def edit; end

  def update
    if @recipe_type.update(recipe_type_params)
      redirect_to @recipe_type
    else
      render :edit
    end
  end

  def destroy
    @recipe_type.destroy
    flash[:alert] = 'Tipo de receita excluído com sucesso'
    redirect_to root_path
  end

  def show; end

  private

  def recipe_type_params
    params.require(:recipe_type).permit(:name)
  end

  def set_recipe_type
    @recipe_type = RecipeType.find(params[:id])
  end
end
