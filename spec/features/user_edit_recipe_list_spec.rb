require 'rails_helper'

feature 'User edit recipe list' do
  scenario 'and change the name' do
    user = create(:user)
    recipe_list = create(:recipe_list, user: user)

    login_as user
    visit root_path
    click_on recipe_list.name
    within 'div.main' do
      click_on 'Editar'
    end

    fill_in 'recipe_list[name]', with: 'Receitas de Natal'
    click_on 'commit'

    expect(page).to have_css('h1', text: 'Receitas de Natal')
  end

  scenario 'and must fill in all fields' do
    user = create(:user)
    recipe_list = create(:recipe_list, user: user)

    login_as user

    visit edit_recipe_list_path(recipe_list)

    fill_in 'recipe_list[name]', with: ''
    click_on 'commit'

    expect(page).to have_content 'Nome não pode ficar em branco'
  end

  scenario 'and delete a recipe from list' do
    user = create(:user)
    recipe_list = create(:recipe_list, user: user)
    recipe = create(:recipe)
    recipe_list.recipes << recipe

    login_as user
    visit recipe_list_path(recipe_list)

    within "li##{recipe.id}" do
      click_on 'delete'
    end

    expect(page).to_not have_css('li', text: recipe.title)
  end

  scenario 'and delete the list' do
    user = create(:user)
    recipe_list = create(:recipe_list, user: user)

    login_as user
    visit recipe_list_path(recipe_list)

    click_on 'delete_list'

    expect(current_path).to eq root_path
    expect(page).to_not have_css('h1', text: recipe_list.name)
  end

  scenario 'must be the list author to edit' do
    user = create(:user)
    author = create(:user)
    recipe_list = create(:recipe_list, user: author)

    login_as user
    visit edit_recipe_list_path(recipe_list)

    expect(current_path).to eq root_path
  end

  scenario 'must be the list author to delete recipes' do
    user = create(:user)
    author = create(:user)
    recipe_list = create(:recipe_list, user: author)
    recipe = create(:recipe)

    recipe_list.recipes << recipe

    login_as user
    visit recipe_list_path(recipe_list)

    within "li##{recipe.id}" do
      expect(page).to_not have_link 'delete'
    end
  end

  scenario 'must be the list author to delete lists' do
    user = create(:user)
    author = create(:user)
    recipe_list = create(:recipe_list, user: author)

    login_as user
    visit recipe_list_path(recipe_list)

    expect(page).to_not have_link 'delete_list'
  end
end
