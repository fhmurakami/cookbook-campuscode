require 'rails_helper'

feature 'Visitor view recipe details' do
  scenario 'successfully' do
    # cria os dados necessarios
    recipe = create(:recipe)

    # simula a acao do usuario
    visit root_path
    click_on recipe.title

    # expectativas do usuario apos a acao
    expect(page).to have_css('h1', text: recipe.title)
    expect(page).to have_css('h3', text: 'Detalhes')
    expect(page).to have_css('p', text: recipe.recipe_type.name)
    expect(page).to have_css('p', text: recipe.cuisine.name)
    expect(page).to have_css('p', text: recipe.difficulty)
    expect(page).to have_css('p', text: "#{recipe.cook_time} minutos")
    expect(page).to have_css('h3', text: 'Ingredientes')
    expect(page).to have_css('p', text: recipe.ingredients)
    expect(page).to have_css('h3', text: 'Como Preparar')
    expect(page).to have_css('p', text: recipe.cook_method)
  end

  scenario 'and view return button' do
    # cria os dados necessarios
    recipe = create(:recipe)

    # simula a acao do usuario
    visit root_path
    click_on recipe.title

    # expectativa da rota atual
    expect(page).to have_css('a.btn.btn-secondary', text: 'Voltar')
  end

  scenario 'and return to recipe list' do
    # cria os dados necessarios
    recipe = create(:recipe)

    # simula a acao do usuario
    visit root_path
    click_on recipe.title
    click_on 'Voltar'

    # expectativa da rota atual
    expect(current_path).to eq(root_path)
  end
end
