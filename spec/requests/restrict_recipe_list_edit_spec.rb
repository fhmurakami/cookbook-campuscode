require 'rails_helper'

RSpec.describe 'Restrict recipe list edit to author' do
  it 'should allow edit to author only' do
    author = create(:user)
    user = create(:user)
    recipe_list = create(:recipe_list, user: author)

    login_as user
    patch recipe_list_path(recipe_list),
          params: { recipe_list: { name: 'Lista de música' } }

    expect(recipe_list.name).to_not eq 'Lista de música'
  end

  it 'should allow delete recipes to author only' do
    author = create(:user)
    user = create(:user)
    recipe_list = create(:recipe_list, user: author)
    recipe = create(:recipe)
    recipe_list.recipes << recipe

    login_as user
    delete recipe_list_delete_recipe_path(recipe_list_id: recipe_list.id,
                                          recipe_id: recipe.id)

    expect(recipe_list.recipes.any?).to be true
    expect(recipe_list.recipes.last).to eq recipe
  end

  it 'try to delete a recipe that do not exists' do
    user = create(:user)
    recipe_list = create(:recipe_list, user: user)
    recipe_type = create(:recipe_type)
    cuisine = create(:cuisine)
    carrot_cake = create(:recipe, recipe_type: recipe_type,
                                  cuisine: cuisine)
    pudim = create(:recipe, title: 'Pudim', recipe_type: recipe_type,
                            cuisine: cuisine)
    recipe_list.recipes << carrot_cake

    login_as user
    delete recipe_list_delete_recipe_path(recipe_list_id: recipe_list.id,
                                          recipe_id: pudim.id)

    expect(response.body).to include 'Erro ao tentar excluir receita'
  end

  it 'should allow only the author to delete a recipe list' do
    author = create(:user)
    user = create(:user)
    recipe_list = create(:recipe_list, user: author)

    login_as user

    delete recipe_list_path(recipe_list)

    expect(RecipeList.any?).to be true
    expect(RecipeList.last).to eq recipe_list
  end
end
