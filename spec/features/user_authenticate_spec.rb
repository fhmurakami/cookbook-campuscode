require 'rails_helper'

feature 'User authenticates' do
  scenario 'user create a new account successfully' do
    visit root_path
    click_on 'Criar conta'

    fill_in 'user[name]', with: 'Usuário'
    fill_in 'user[email]', with: 'usuario@email.com'
    fill_in 'user[password]', with: '123456'
    fill_in 'user[password_confirmation]', with: '123456'
    fill_in 'user[city]', with: 'São Paulo'
    within 'form#new_user' do
      click_on 'Criar conta'
    end

    expect(current_path).to eq root_path
    expect(page).to have_css('p', text: 'Olá, usuario@email.com')
    expect(page).to have_link 'Sair'
    expect(page).to_not have_link 'Criar conta'
    expect(page).to_not have_link 'Entrar'
  end

  scenario 'user try to create new account without fill all fields' do
    visit root_path
    click_on 'Criar conta'

    fill_in 'user[name]', with: ''
    fill_in 'user[email]', with: ''
    fill_in 'user[password]', with: ''
    fill_in 'user[password_confirmation]', with: ''
    fill_in 'user[city]', with: ''
    within 'form#new_user' do
      click_on 'Criar conta'
    end

    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Email não pode ficar em branco'
    expect(page).to have_content 'Senha não pode ficar em branco'
    expect(page).to have_content 'Cidade não pode ficar em branco'
  end

  scenario 'user sign in' do
    user = create(:user)

    visit root_path
    click_on 'Entrar'

    fill_in 'Email', with: user.email
    fill_in 'Senha', with: user.password
    within 'form#new_user' do
      click_on 'Entrar'
    end

    expect(current_path).to eq root_path
    expect(page).to have_css('p', text: "Olá, #{user.email}")
    expect(page).to have_link 'Sair'
    expect(page).to_not have_link 'Criar conta'
    expect(page).to_not have_link 'Entrar'
  end

  scenario 'user sign out' do
    user = create(:user)
    login_as(user)

    visit root_path
    click_on 'Sair'

    expect(current_path).to eq root_path
    expect(page).to have_link 'Criar conta'
    expect(page).to have_link 'Entrar'
    expect(page).to_not have_css('p', text: "Olá, #{user.email}")
    expect(page).to_not have_link 'Sair'
  end

  scenario 'user delete account' do
    user = create(:user)

    login_as(user)
    visit user_path(user)
    click_on 'delete_account'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Adeus! '\
      'A sua conta foi cancelada com sucesso.'\
      ' Esperamos vê-lo novamente em breve.'
    expect(page).to have_link 'Criar conta'
    expect(page).to have_link 'Entrar'

    expect(page).to_not have_css('p', text: 'Olá, usuario@email.com')
    expect(page).to_not have_link 'Sair'
  end
end
