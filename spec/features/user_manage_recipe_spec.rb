require 'rails_helper'

feature 'User manage recipes' do
  scenario 'if not signed in' do
    recipe = create(:recipe)

    visit recipe_path(recipe)

    expect(page).to have_link 'Entrar', href: new_user_session_path

    expect(page).to_not have_link 'Editar', href: edit_recipe_path(recipe)
    expect(page).to_not have_link 'Excluir', href: recipe_path(recipe)
  end

  scenario 'if signed in and recipe\'s author' do
    user = create(:user)
    recipe = create(:recipe, user: user)

    login_as user
    visit recipe_path(recipe)

    expect(page).to have_content "Criada por: #{user.email}"
    expect(page).to have_link 'Editar', href: edit_recipe_path(recipe)
    expect(page).to have_link 'Excluir', href: recipe_path(recipe)
    expect(page).to have_link 'Sair', href: destroy_user_session_path

    expect(page).to_not have_link 'Entrar', href: new_user_session_path
  end

  scenario 'if not recipe\'s author' do
    author = create(:user, email: 'author@emai.com')
    user = create(:user)
    recipe = create(:recipe, user: author)

    login_as user
    visit recipe_path(recipe)

    within('.main') do
      expect(page).to_not have_link 'Editar', href: edit_recipe_path(recipe)
      expect(page).to_not have_link 'Excluir', href: recipe_path(recipe)
    end
  end

  scenario 'if try to edit recipe from another user' do
    author = create(:user, email: 'author@emai.com')
    user = create(:user)
    recipe = create(:recipe, user: author)

    login_as user
    visit edit_recipe_path(recipe)

    expect(current_path).to eq root_path
  end
end
