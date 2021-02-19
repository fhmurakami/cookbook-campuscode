class RecipeListsController < ApplicationController
  before_action :set_recipe_list,
                only: %i[show edit update destroy delete_recipe]
  before_action :authenticate_user!,
                only: %i[new create edit update destroy delete_recipe]
  before_action :verify_list_author, only: %i[edit update destroy delete_recipe]

  def show; end

  def new
    @recipe_list = RecipeList.new
    @recipes = Recipe.all
  end

  def create
    @recipe_list = current_user.recipe_lists.new(recipe_list_params)
    if @recipe_list.save
      redirect_to @recipe_list
    else
      @recipes = Recipe.all
      render :new
    end
  end

  def edit; end

  def update
    if @recipe_list.update(recipe_list_params)
      redirect_to @recipe_list
    else
      render :edit
    end
  end

  def destroy
    @recipe_list.destroy
    flash[:alert] = 'Lista de receitas excluída com sucesso'
    redirect_to root_path
  end

  def delete_recipe
    recipe = @recipe_list.recipes.find_by(id: params[:recipe_id])
    if recipe && @recipe_list.recipes.delete(recipe)
      flash[:notice] = 'Receita excluída com sucesso'
    else
      flash[:alert] = 'Erro ao tentar excluir receita'
    end
    render :show
  end

  private

  def recipe_list_params
    params.require(:recipe_list).permit(:name)
  end

  def set_recipe_list
    return @recipe_list = RecipeList.find(params[:id]) if params[:id]

    @recipe_list = RecipeList.find(params[:recipe_list_id])
  end

  def verify_list_author
    set_recipe_list
    redirect_to root_path unless current_user.author?(@recipe_list)
  end
end
