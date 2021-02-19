require 'rails_helper'

feature 'Admin register recipe_type' do
  scenario 'successfully' do
    admin = create(:user, admin: true)

    login_as admin
    visit root_path
    click_on 'Cadastrar tipo de receita'
    fill_in 'Nome', with: 'Sobremesa'
    click_on 'Enviar'

    expect(page).to have_css('h1', text: 'Sobremesa')
  end

  scenario 'and must fill in name' do
    admin = create(:user, admin: true)

    login_as admin
    visit new_recipe_type_path
    fill_in 'Nome', with: ''
    click_on 'Enviar'

    expect(page).to have_content('Nome não pode ficar em branco')
  end

  scenario 'and must be unique' do
    admin = create(:user, admin: true)
    create(:recipe_type, name: 'Sobremesa')

    login_as admin
    visit new_recipe_type_path
    fill_in 'Nome', with: 'Sobremesa'
    click_on 'Enviar'

    expect(page).to have_content('Tipo de receita já existente')
  end

  scenario 'and must be case unsensitive' do
    admin = create(:user, admin: true)
    create(:recipe_type, name: 'Sobremesa')

    login_as admin
    visit new_recipe_type_path
    fill_in 'Nome', with: 'sobremesa'
    click_on 'Enviar'

    expect(page).to have_content('Tipo de receita já existente')
  end
end
