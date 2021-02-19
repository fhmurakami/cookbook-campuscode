require 'rails_helper'

feature 'Admin edits recipe type' do
  scenario 'successfully' do
    admin = create(:user, admin: true)
    recipe_type = create(:recipe_type, name: 'Sorbemesa')

    login_as admin
    visit root_path
    click_on recipe_type.name
    click_on 'edit'

    fill_in 'recipe_type[name]', with: 'Sobremesa'
    click_on 'commit'

    expect(current_path).to eq recipe_type_path(recipe_type)
    expect(page).to have_css('h1', text: 'Sobremesa')
  end

  scenario 'and must fill in all fields' do
    admin = create(:user, admin: true)
    recipe_type = create(:recipe_type, name: 'Sobremesa')

    login_as admin
    visit edit_recipe_type_path(recipe_type)

    fill_in 'recipe_type[name]', with: ''
    click_on 'commit'

    expect(page).to have_content('Nome não pode ficar em branco')
  end

  scenario 'and must be unique' do
    admin = create(:user, admin: true)
    dessert = create(:recipe_type, name: 'Sobremesa')
    create(:recipe_type, name: 'Entrada')

    login_as admin
    visit edit_recipe_type_path(dessert)

    fill_in 'recipe_type[name]', with: 'Entrada'
    click_on 'commit'

    expect(page).to have_content('Tipo de receita já existente')
  end
end
