require 'rails_helper'

feature 'Visitor visit homepage' do
  scenario 'successfully' do
    visit root_path

    expect(page).to have_css('h1', text: 'CookBook')
    expect(page).to have_css('p', text: 'Bem-vindo ao maior livro de receitas'\
      ' online')
  end

  scenario 'and view recipe' do
    # cria os dados necessarios
    recipe = create(:recipe)

    # simula a acao do usuario
    visit root_path

    # expectativas do usuario apos a acao
    expect(page).to have_css('h1', text: recipe.title)
    expect(page).to have_css('li', text: recipe.recipe_type.name)
    expect(page).to have_css('li', text: recipe.cuisine.name)
    expect(page).to have_css('li', text: recipe.difficulty)
    expect(page).to have_css('li', text: "#{recipe.cook_time} minutos")
  end

  scenario 'and view recipes list' do
    # cria os dados necessarios
    user = create(:user)
    recipe_type = create(:recipe_type)
    cuisine = create(:cuisine)
    recipe = create(:recipe, title: 'Bolo de cenoura', recipe_type: recipe_type,
                             cuisine: cuisine, user: user)
    another_recipe = create(:recipe, title: 'Feijoada',
                                     recipe_type: recipe_type,
                                     cuisine: cuisine, user: user)

    # simula a acao do usuario
    visit root_path

    # expectativas do usuario apos a acao
    expect(page).to have_css('h1', text: recipe.title)
    expect(page).to have_css('li', text: recipe.recipe_type.name)
    expect(page).to have_css('li', text: recipe.cuisine.name)
    expect(page).to have_css('li', text: recipe.difficulty)
    expect(page).to have_css('li', text: "#{recipe.cook_time} minutos")

    expect(page).to have_css('h1', text: another_recipe.title)
    expect(page).to have_css('li', text: another_recipe.recipe_type.name)
    expect(page).to have_css('li', text: another_recipe.cuisine.name)
    expect(page).to have_css('li', text: another_recipe.difficulty)
    expect(page).to have_css('li', text: "#{another_recipe.cook_time} minutos")
  end

  scenario 'and view the latest recipes' do
    user = create(:user)
    recipe_type = create(:recipe_type)
    cuisine = create(:cuisine)
    old_recipe = create(:recipe, title: 'Receita antiga',
                                 recipe_type: recipe_type,
                                 cuisine: cuisine, user: user)
    create(:recipe, title: 'Bolo de cenoura',
                    recipe_type: recipe_type,
                    cuisine: cuisine, user: user)
    create(:recipe, title: 'Bolo de chocolate',
                    recipe_type: recipe_type,
                    cuisine: cuisine, user: user)
    create(:recipe, title: 'Bolo de morango',
                    recipe_type: recipe_type,
                    cuisine: cuisine, user: user)
    create(:recipe, title: 'Torta de maçã',
                    recipe_type: recipe_type,
                    cuisine: cuisine, user: user)
    create(:recipe, title: 'Torta de framboesa',
                    recipe_type: recipe_type,
                    cuisine: cuisine, user: user)
    create(:recipe, title: 'Torta de abacaxi',
                    recipe_type: recipe_type,
                    cuisine: cuisine, user: user)

    visit root_path

    within 'section#latest' do
      expect(page).to have_css('div.recipe', count: 6)

      expect(page).to_not have_css('h1', text: old_recipe.title)
    end
  end

  scenario 'and view all recipes' do
    user = create(:user)
    recipe_type = create(:recipe_type)
    cuisine = create(:cuisine)
    recipe = create(:recipe, title: 'Receita antiga',
                             recipe_type: recipe_type,
                             cuisine: cuisine, user: user)

    visit root_path
    click_on 'Todas as receitas'

    within 'section#all' do
      expect(page).to have_css('h1', text: recipe.title)
    end
  end
end
