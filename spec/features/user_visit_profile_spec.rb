require 'rails_helper'

feature 'User visit user profile' do
  scenario 'from recipe page' do
    user = create(:user)
    recipe = create(:recipe, user: user)

    login_as user
    visit root_path
    click_on recipe.title
    click_on user.email

    expect(page).to have_css('h1', text: 'Dados do usuário')
    expect(page).to have_css('h2', text: user.name)
    expect(page).to have_css('h5', text: user.email)
    expect(page).to have_css('h5', text: user.city)
    within 'section#recipes' do
      expect(page).to have_css('h3', text: "Receitas de #{user.name}")
      expect(page).to have_css('h1', text: recipe.title)
    end
  end

  scenario 'from recipe_list page' do
    user = create(:user)
    recipe_list = create(:recipe_list, user: user)

    login_as user
    visit recipe_list_path(recipe_list)
    click_on user.name

    expect(page).to have_css('h1', text: 'Dados do usuário')
    expect(page).to have_css('h2', text: user.name)
    expect(page).to have_css('h5', text: user.email)
    expect(page).to have_css('h5', text: user.city)
    within 'section#lists' do
      expect(page).to have_css('h3', text: "Listas de receitas de #{user.name}")
      expect(page).to have_link recipe_list.name
    end
  end

  scenario 'and user has no recipes' do
    user = create(:user)

    login_as user
    visit user_path(user)

    expect(page).to have_css('h1', text: 'Dados do usuário')
    expect(page).to have_css('h2', text: user.name)
    expect(page).to have_css('h5', text: user.email)
    expect(page).to have_css('h5', text: user.city)
    within 'section#recipes' do
      expect(page).to have_css('h3', text: "Receitas de #{user.name}")
      expect(page).to have_css('p', text: 'Esse usuário não possui nenhuma'\
        ' receita cadastrada')
    end
  end

  scenario 'and user has no lists' do
    user = create(:user)

    login_as user
    visit user_path(user)

    expect(page).to have_css('h1', text: 'Dados do usuário')
    expect(page).to have_css('h2', text: user.name)
    expect(page).to have_css('h5', text: user.email)
    expect(page).to have_css('h5', text: user.city)
    within 'section#lists' do
      expect(page).to have_css('h3', text: "Listas de receitas de #{user.name}")
      expect(page).to have_css('p', text: 'Esse usuário não possui nenhuma'\
        ' lista cadastrada')
    end
  end
end
