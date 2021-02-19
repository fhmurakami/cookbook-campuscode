require 'rails_helper'

feature 'Admin register cuisine' do
  scenario 'successfully' do
    admin = create(:user, admin: true)

    login_as admin
    visit root_path
    click_on 'Cadastrar cozinha'
    fill_in 'Nome', with: 'Arabe'
    click_on 'Enviar'

    expect(page).to have_css('h1', text: 'Arabe')
  end

  scenario 'and must fill in name' do
    admin = create(:user, admin: true)

    login_as admin
    visit new_cuisine_path
    fill_in 'Nome', with: ''
    click_on 'Enviar'

    expect(page).to have_content('Nome não pode ficar em branco')
  end

  scenario 'and must be unique' do
    admin = create(:user, admin: true)
    create(:cuisine, name: 'Italiana')

    login_as admin
    visit new_cuisine_path
    fill_in 'Nome', with: 'Italiana'
    click_on 'Enviar'

    expect(page).to have_content('Cozinha já existente')
  end

  scenario 'and must be case unsensitive' do
    admin = create(:user, admin: true)
    create(:cuisine, name: 'Italiana')

    login_as admin
    visit new_cuisine_path
    fill_in 'Nome', with: 'italiana'
    click_on 'Enviar'

    expect(page).to have_content('Cozinha já existente')
  end
end
