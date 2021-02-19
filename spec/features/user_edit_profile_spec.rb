require 'rails_helper'

feature 'User edit profile' do
  scenario 'successfully' do
    user = create(:user)

    login_as user
    visit root_path
    within 'nav' do
      click_on 'Editar perfil'
    end

    fill_in 'user[name]', with: 'Felipe'
    fill_in 'user[city]', with: 'São Paulo'
    fill_in 'user[facebook]', with: 'facebook.com'
    fill_in 'user[twitter]', with: 'twitter.com'
    attach_file 'user[photo]', Rails.root.join('spec', 'support', 'user.png')
    click_on 'Editar'

    expect(page).to have_css("img[src*='user']")
    expect(page).to have_css('h2', text: 'Felipe')
    expect(page).to have_css('h5', text: user.email)
    expect(page).to have_css('h5', text: 'São Paulo')
    expect(page).to have_link 'Facebook', href: 'facebook.com'
    expect(page).to have_link 'Twitter', href: 'twitter.com'
  end

  scenario 'and must fill in all required fields' do
    user = create(:user)

    login_as user
    visit edit_user_path(user)

    fill_in 'user[name]', with: ''
    fill_in 'user[city]', with: ''
    click_on 'Editar'

    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Cidade não pode ficar em branco'
  end
end
