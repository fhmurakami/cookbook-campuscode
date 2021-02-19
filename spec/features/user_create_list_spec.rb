require 'rails_helper'

feature 'User create recipe list' do
  scenario 'successfully' do
    user = create(:user)

    login_as user
    visit root_path
    click_on 'Criar lista de receitas'

    fill_in 'Nome', with: 'Receitas de Natal'
    within 'div.container form' do
      click_on 'Criar lista'
    end

    expect(page).to have_css('h1', text: 'Receitas de Natal')
  end

  scenario 'and must fill in all fields' do
    user = create(:user)
    create(:recipe)

    login_as user
    visit new_recipe_list_path

    fill_in 'Nome', with: ''
    within 'div.container form' do
      click_on 'Criar lista'
    end

    expect(page).to have_css('p', text: 'Nome não pode ficar em branco')
  end

  scenario 'and add recipe to list' do
    user = create(:user)
    recipe_type = create(:recipe_type)
    cuisine = create(:cuisine)
    recipe = create(:recipe, recipe_type: recipe_type,
                             cuisine: cuisine, user: user)
    pudim = create(:recipe, title: 'Pudim', recipe_type: recipe_type,
                            cuisine: cuisine, user: user)
    recipe_list = create(:recipe_list, user: user)

    login_as user
    visit recipe_path(recipe)
    click_on 'Adicionar à lista'

    visit recipe_list_path(recipe_list)

    expect(page).to have_css('h1', text: recipe_list.name)
    expect(page).to have_css('li', text: recipe.title)
    expect(page).to_not have_css('li', text: pudim.title)
  end

  scenario 'and recipes should not repeat' do
    user = create(:user)
    recipe = create(:recipe)
    recipe_list = create(:recipe_list, user: user)

    recipe_list.recipes << recipe

    login_as user
    visit recipe_path(recipe)
    click_on 'Adicionar à lista'

    expect(page).to have_css('p', text: 'Essa receita já está na lista '\
      "#{recipe_list.name}")
  end
end
