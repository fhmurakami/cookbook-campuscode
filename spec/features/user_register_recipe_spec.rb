require 'rails_helper'

feature 'User register recipe' do
  scenario 'view send link if signed in' do
    user = create(:user)

    login_as user
    visit root_path

    expect(page).to have_link('Home', href: root_path, class: 'nav-link')
    expect(page).to have_link('Enviar uma receita', href: new_recipe_path,
                                                    class: 'nav-link')
  end

  scenario 'don\'t view send link if not signed in' do
    visit root_path

    expect(page).to_not have_link('Enviar uma receita', href: new_recipe_path,
                                                        class: 'nav-link')
  end

  scenario 'successfully' do
    # cria os dados necessarios, nesse caso nao vamos criar dados no banco
    user = create(:user)
    RecipeType.create(name: 'Sobremesa')
    RecipeType.create(name: 'Entrada')
    Cuisine.create(name: 'Arabe')

    # simula a acao do usuario
    login_as user
    visit root_path
    click_on 'Enviar uma receita'

    fill_in 'Título', with: 'Tabule'
    select 'Entrada', from: 'Tipo da Receita'
    select 'Arabe', from: 'Cozinha'
    fill_in 'Dificuldade', with: 'Fácil'
    fill_in 'Tempo de Preparo', with: '45'
    fill_in 'Ingredientes', with: 'Trigo para quibe, cebola, '\
                                  'tomate picado, azeite, salsinha'
    fill_in 'Como Preparar', with: 'Misturar tudo e servir. '\
                                   'Adicione limão a gosto.'
    attach_file 'Foto', Rails.root.join('spec', 'support', 'tabule.jpg')
    click_on 'Enviar'

    # expectativas
    expect(page).to have_css('h1', text: 'Tabule')
    expect(page).to have_css('p', text: "Criada por: #{user.email}")
    expect(page).to have_css('h3', text: 'Detalhes')
    expect(page).to have_css('p', text: 'Entrada')
    expect(page).to have_css('p', text: 'Arabe')
    expect(page).to have_css('p', text: 'Fácil')
    expect(page).to have_css('p', text: '45 minutos')
    expect(page).to have_css('h3', text: 'Ingredientes')
    expect(page).to have_css('p', text: 'Trigo para quibe, cebola, '\
      'tomate picado, azeite, salsinha')
    expect(page).to have_css('h3', text: 'Como Preparar')
    expect(page).to have_css('p', text: 'Misturar tudo e servir. '\
      'Adicione limão a gosto.')
    expect(page).to have_css("img[src*='tabule']")
  end

  scenario 'and must fill in all fields' do
    # simula a acao do usuario
    user = create(:user)

    login_as user
    visit root_path
    click_on 'Enviar uma receita'

    fill_in 'Título', with: ''
    fill_in 'Dificuldade', with: ''
    fill_in 'Tempo de Preparo', with: ''
    fill_in 'Ingredientes', with: ''
    fill_in 'Como Preparar', with: ''
    click_on 'Enviar'

    expect(page).to have_content('Você deve informar todos os dados da receita')
  end
end
