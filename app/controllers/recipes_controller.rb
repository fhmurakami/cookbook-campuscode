class RecipesController < ApplicationController
  before_action :set_recipe,
                only: %i[show edit update destroy add_to_list featured]
  before_action :authenticate_user!, only: %i[new create edit update destroy]
  before_action :verify_author, only: %i[edit update destroy]
  before_action :set_recipe_list, only: %i[add_to_list]
  before_action :user_admin?, only: %i[featured]

  def add_to_list
    if @recipe_list.recipe?(@recipe)
      flash.now[:alert] = "Essa receita já está na lista #{@recipe_list.name}"
    else
      @recipe_list.recipes << @recipe
      flash.now[:alert] = "Receita adiciona à lista #{@recipe_list.name}"
    end
    render :show
  end

  def index
    @latest_recipes = Recipe.last(6)
    @recipe_types = RecipeType.all
    @cuisines = Cuisine.all
    @recipe_lists = RecipeList.all
  end

  def show; end

  def new
    @recipe_types = RecipeType.all
    @cuisines = Cuisine.all
    @recipe = Recipe.new
  end

  def create
    @recipe = current_user.recipes.new(recipe_params)
    if @recipe.save
      redirect_to @recipe
    else
      @recipe_types = RecipeType.all
      @cuisines = Cuisine.all
      render :new
    end
  end

  def edit
    @recipe_types = RecipeType.all
    @cuisines = Cuisine.all
  end

  def update
    if @recipe.update(recipe_params)
      redirect_to @recipe
    else
      @recipe_types = RecipeType.all
      @cuisines = Cuisine.all
      render :edit
    end
  end

  def destroy
    @recipe.destroy
    flash[:alert] = 'Receita excluída com sucesso'
    redirect_to root_path
  end

  def featured
    @recipe.featured = true
    @recipe.save
    redirect_to @recipe
  end

  def search
    @recipes = Recipe.where('title like ?', "%#{params[:search]}%")
  end

  def all
    @recipes = Recipe.all
    @recipe_types = RecipeType.all
    @cuisines = Cuisine.all
  end

  private

  def recipe_params
    params.require(:recipe).permit(:title, :recipe_type_id, :cuisine_id,
                                   :difficulty, :cook_time, :ingredients,
                                   :cook_method, :photo)
  end

  def set_recipe
    return @recipe = Recipe.find(params[:id]) if params[:id]

    @recipe = Recipe.find(params[:recipe_id])
  end

  def set_recipe_list
    @recipe_list = RecipeList.find(params[:list_id])
  end

  def verify_author
    set_recipe
    redirect_to root_path unless current_user.author?(@recipe)
  end
end
