require 'rails_helper'

feature 'visitor search recipes' do
  scenario 'and find the correct recipe' do
    user = create(:user)
    cuisine = create(:cuisine)
    recipe_type = create(:recipe_type)
    carrot_cake = create(:recipe, title: 'Bolo de cenoura', cuisine: cuisine,
                                  recipe_type: recipe_type, user: user)
    apple_pie = create(:recipe, title: 'Torta de maçã', cuisine: cuisine,
                                recipe_type: recipe_type, user: user)

    visit root_path
    fill_in 'Buscar', with: 'Bolo de cenoura'
    click_on 'Pesquisar'

    expect(page).to have_css('h1', text: 'Resultados da pesquisa')
    expect(page).to have_css('h1', text: carrot_cake.title)

    expect(page).to_not have_css('h1', text: apple_pie.title)
  end

  scenario 'and not find recipes' do
    recipe = create(:recipe, title: 'Bolo de cenoura')

    visit root_path
    fill_in 'Buscar', with: 'Pudim'
    click_on 'Pesquisar'

    expect(page).to have_css('h1', text: 'Resultados da pesquisa')
    expect(page).to have_css('p', text: 'Nenhuma receita encontrada.')

    expect(page).to_not have_css('h1', text: recipe.title)
  end

  scenario 'and find more than one' do
    user = create(:user)
    cuisine = create(:cuisine)
    recipe_type = create(:recipe_type)
    carrot_cake = create(:recipe, title: 'Bolo de cenoura', cuisine: cuisine,
                                  recipe_type: recipe_type, user: user)
    chocolate_cake = create(:recipe, title: 'Bolo de chocolate',
                                     cuisine: cuisine, recipe_type: recipe_type,
                                     user: user)
    pudim = create(:recipe, title: 'Pudim', cuisine: cuisine,
                            recipe_type: recipe_type, user: user)

    visit root_path
    fill_in 'Buscar', with: 'Bolo'
    click_on 'Pesquisar'

    expect(page).to have_css('h1', text: 'Resultados da pesquisa')
    expect(page).to have_css('h1', text: carrot_cake.title)
    expect(page).to have_css('h1', text: chocolate_cake.title)

    expect(page).to_not have_css('h1', text: pudim.title)
  end
end
