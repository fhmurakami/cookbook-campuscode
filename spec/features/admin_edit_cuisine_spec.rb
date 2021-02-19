require 'rails_helper'

feature 'Admin edits cuisine' do
  scenario 'successfully' do
    admin = create(:user, admin: true)
    cuisine = create(:cuisine, name: 'Potruguesa')

    login_as admin
    visit root_path
    click_on cuisine.name
    click_on 'edit'

    fill_in 'cuisine[name]', with: 'Portuguesa'
    click_on 'commit'

    expect(current_path).to eq cuisine_path(cuisine)
    expect(page).to have_css('h1', text: 'Portuguesa')
  end

  scenario 'and must fill in all fields' do
    admin = create(:user, admin: true)
    cuisine = create(:cuisine, name: 'Portuguesa')

    login_as admin
    visit edit_cuisine_path(cuisine)

    fill_in 'cuisine[name]', with: ''
    click_on 'commit'

    expect(page).to have_content('Nome não pode ficar em branco')
  end

  scenario 'and must be unique' do
    admin = create(:user, admin: true)
    portuguese = create(:cuisine, name: 'Portuguesa')
    create(:cuisine, name: 'Alemã')

    login_as admin
    visit edit_cuisine_path(portuguese)

    fill_in 'cuisine[name]', with: 'Alemã'
    click_on 'commit'

    expect(page).to have_content('Cozinha já existente')
  end
end
