require 'rails_helper'

feature 'User update recipe' do
  scenario 'view edit button' do
    user = create(:user)
    create(:recipe, user: user)

    login_as user
    visit root_path
    click_on 'Bolo de cenoura'

    expect(page).to have_css('a.btn.btn-primary', text: 'Editar')
  end

  scenario 'successfully' do
    user = create(:user)

    dessert = create(:recipe_type, name: 'Sobremesa')
    create(:recipe_type, name: 'Entrada')

    cuisine = create(:cuisine, name: 'Brasileira')
    create(:cuisine, name: 'Arabe')

    create(:recipe, title: 'Bolodecenoura', difficulty: 'Médio',
                    recipe_type: dessert, cuisine: cuisine,
                    cook_time: 50, ingredients: 'Farinha, açucar, cenoura',
                    cook_method: 'Cozinhe a cenoura, corte em pedaços '\
                                 'pequenos, misture com o restante dos'\
                                 ' ingredientes',
                    user: user)

    # simula a acao do usuario
    login_as user
    visit root_path
    click_on 'Bolodecenoura'
    click_on 'Editar'

    fill_in 'Título', with: 'Bolo de cenoura'
    select 'Entrada', from: 'Tipo da Receita'
    select 'Arabe', from: 'Cozinha'
    fill_in 'Dificuldade', with: 'Médio'
    fill_in 'Tempo de Preparo', with: '45'
    fill_in 'Ingredientes', with: 'Cenoura, farinha, ovo, oleo de soja e '\
                                  'chocolate'
    fill_in 'Como Preparar', with: 'Faça um bolo e uma cobertura de chocolate'

    click_on 'Enviar'

    expect(page).to have_css('h1', text: 'Bolo de cenoura')
    expect(page).to have_css('h3', text: 'Detalhes')
    expect(page).to have_css('p', text: 'Arabe')
    expect(page).to have_css('p', text: 'Entrada')
    expect(page).to have_css('p', text: 'Médio')
    expect(page).to have_css('p', text: '45 minutos')
    expect(page).to have_css('p', text: 'Cenoura, farinha, ovo, oleo de soja e'\
                                        ' chocolate')
    expect(page).to have_css('p', text: 'Faça um bolo e uma cobertura de '\
                                        'chocolate')
  end

  scenario 'and must fill in all fields' do
    user = create(:user)
    create(:recipe, title: 'Bolodecenoura', user: user)

    # simula a acao do usuario
    login_as user
    visit root_path
    click_on 'Bolodecenoura'
    click_on 'Editar'

    fill_in 'Título', with: ''
    fill_in 'Dificuldade', with: ''
    fill_in 'Tempo de Preparo', with: ''
    fill_in 'Ingredientes', with: ''
    fill_in 'Como Preparar', with: ''
    click_on 'Enviar'

    expect(page).to have_content('Você deve informar todos os dados da receita')
  end
end
